package com.emrDAO;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.stream.Stream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.emrBean.HistoryBean;

public class EmrRecordStorage {
    private static final String STORAGE_ENV = "EMR_STORAGE_DIR";

    private EmrRecordStorage() {}

    public static void save(HistoryBean h) {
        try {
            Path patientDir = getPatientDir(h.getPatientId());

            String json = toJson(h);
            String markdown = toMarkdown(h);
            String text = toText(h);

            String fileBaseName = nextRecordFileBaseName(patientDir, h.getPatientId());
            Path jsonPath = patientDir.resolve(fileBaseName + ".json");
            Path mdPath = patientDir.resolve(fileBaseName + ".md");
            Path txtPath = patientDir.resolve(fileBaseName + ".txt");

            Files.write(jsonPath, json.getBytes(StandardCharsets.UTF_8));
            Files.write(mdPath, markdown.getBytes(StandardCharsets.UTF_8));
            Files.write(txtPath, text.getBytes(StandardCharsets.UTF_8));

            h.setEmrJsonPath(toRelative(jsonPath));
            h.setEmrMdPath(toRelative(mdPath));
            h.setEmrTxtPath(toRelative(txtPath));
        } catch (IOException e) {
            throw new RuntimeException("EMR 파일 저장 실패: " + e.getMessage(), e);
        }
    }

    public static Path saveVoiceDraft(String patientId, String transcript) {
        try {
            Path patientDir = getPatientDir(patientId);
            Path voicePath = patientDir.resolve("VoiceEMR.json");
            String json = "{\n"
                + "  \"patient_id\": " + q(patientId) + ",\n"
                + "  \"created_at\": " + q(LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)) + ",\n"
                + "  \"ready_for_summary\": true,\n"
                + "  \"source\": \"browser_speech_recognition\",\n"
                + "  \"transcript\": " + q(transcript) + "\n"
                + "}\n";
            Files.write(voicePath, json.getBytes(StandardCharsets.UTF_8));
            return voicePath;
        } catch (IOException e) {
            throw new RuntimeException("음성 EMR 파일 저장 실패: " + e.getMessage(), e);
        }
    }

    public static boolean loadInto(HistoryBean h) {
        if (h.getEmrJsonPath() == null || h.getEmrJsonPath().trim().isEmpty()) {
            return false;
        }

        try {
            Path jsonPath = resolveStoredPath(h.getEmrJsonPath());
            if (!Files.exists(jsonPath)) {
                return false;
            }

            String json = new String(Files.readAllBytes(jsonPath), StandardCharsets.UTF_8);
            h.setChiefComplaint(readJsonString(json, "chief_complaint"));
            h.setPresentIllness(readJsonString(json, "present_illness"));
            h.setPastHistory(readJsonString(json, "past_history"));
            h.setLabResults(readJsonString(json, "lab_results"));
            h.setImagingResults(readJsonString(json, "imaging_results"));
            h.setDiagnosis(readJsonString(json, "diagnosis"));
            h.setPlan(readJsonString(json, "plan"));
            h.setFreeText(readJsonString(json, "free_text"));
            h.setSymptomDetail(h.getChiefComplaint());
            h.setMemo(h.getPlan());
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static Path getBaseDir() {
        String envDir = System.getenv(STORAGE_ENV);
        if (envDir != null && !envDir.trim().isEmpty()) {
            return Paths.get(envDir);
        }

        String catalinaBase = System.getProperty("catalina.base");
        if (catalinaBase != null && !catalinaBase.trim().isEmpty()) {
            return Paths.get(catalinaBase, "emr-storage");
        }

        return Paths.get(System.getProperty("user.home"), "emr-storage");
    }

    private static Path getPatientDir(String patientId) throws IOException {
        Path patientDir = getBaseDir().resolve("patients").resolve(safeFileName(patientId));
        Files.createDirectories(patientDir);
        return patientDir;
    }

    private static String nextRecordFileBaseName(Path patientDir, String patientId) throws IOException {
        String datePart = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE);
        String safePatientId = safeFileName(patientId);
        String prefix = datePart + safePatientId;
        int maxSeq = 0;

        try (Stream<Path> paths = Files.list(patientDir)) {
            maxSeq = paths
                .map(path -> path.getFileName().toString())
                .filter(name -> name.startsWith(prefix) && name.endsWith(".json"))
                .map(name -> name.substring(prefix.length(), name.length() - 5))
                .filter(seq -> seq.matches("\\d{3}"))
                .mapToInt(Integer::parseInt)
                .max()
                .orElse(0);
        }

        return prefix + String.format("%03d", maxSeq + 1);
    }

    private static String safeFileName(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "UNKNOWN";
        }
        return value.replaceAll("[^A-Za-z0-9_-]", "_");
    }

    private static String toRelative(Path path) {
        Path base = getBaseDir().toAbsolutePath().normalize();
        Path normalized = path.toAbsolutePath().normalize();
        return base.relativize(normalized).toString().replace("\\", "/");
    }

    private static Path resolveStoredPath(String storedPath) {
        Path path = Paths.get(storedPath);
        if (path.isAbsolute()) {
            return path;
        }
        return getBaseDir().resolve(storedPath).normalize();
    }

    private static String toJson(HistoryBean h) {
        return "{\n"
            + "  \"history_id\": " + q(h.getId()) + ",\n"
            + "  \"patient_id\": " + q(h.getPatientId()) + ",\n"
            + "  \"employee_id\": " + q(h.getEmployeeId()) + ",\n"
            + "  \"dept_id\": " + q(h.getDeptId()) + ",\n"
            + "  \"saved_at\": " + q(LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)) + ",\n"
            + "  \"vitals\": {\n"
            + "    \"height\": " + q(Float.toString(h.getHeight())) + ",\n"
            + "    \"weight\": " + q(Float.toString(h.getWeight())) + ",\n"
            + "    \"bp_systolic\": " + q(Integer.toString(h.getBpSystolic())) + ",\n"
            + "    \"bp_diastolic\": " + q(Integer.toString(h.getBpDiastolic())) + ",\n"
            + "    \"temp\": " + q(Float.toString(h.getTemp())) + ",\n"
            + "    \"hr\": " + q(h.getHr()) + ",\n"
            + "    \"rr\": " + q(h.getRr()) + ",\n"
            + "    \"spo2\": " + q(h.getSpo2()) + "\n"
            + "  },\n"
            + "  \"chief_complaint\": " + q(h.getChiefComplaint()) + ",\n"
            + "  \"present_illness\": " + q(h.getPresentIllness()) + ",\n"
            + "  \"past_history\": " + q(h.getPastHistory()) + ",\n"
            + "  \"lab_results\": " + q(h.getLabResults()) + ",\n"
            + "  \"imaging_results\": " + q(h.getImagingResults()) + ",\n"
            + "  \"diagnosis\": " + q(h.getDiagnosis()) + ",\n"
            + "  \"plan\": " + q(h.getPlan()) + ",\n"
            + "  \"free_text\": " + q(h.getFreeText()) + "\n"
            + "}\n";
    }

    private static String toMarkdown(HistoryBean h) {
        return "# EMR Record " + nvl(h.getId()) + "\n\n"
            + "## Patient\n\n"
            + "- Patient ID: " + nvl(h.getPatientId()) + "\n"
            + "- Doctor ID: " + nvl(h.getEmployeeId()) + "\n"
            + "- Department ID: " + nvl(h.getDeptId()) + "\n\n"
            + "## Vitals\n\n"
            + "- Height: " + h.getHeight() + "\n"
            + "- Weight: " + h.getWeight() + "\n"
            + "- BP: " + h.getBpSystolic() + "/" + h.getBpDiastolic() + "\n"
            + "- Temp: " + h.getTemp() + "\n"
            + "- HR: " + nvl(h.getHr()) + "\n"
            + "- RR: " + nvl(h.getRr()) + "\n"
            + "- SpO2: " + nvl(h.getSpo2()) + "\n\n"
            + "## S. Subjective\n\n"
            + "### Chief Complaint\n\n" + nvl(h.getChiefComplaint()) + "\n\n"
            + "### Present Illness\n\n" + nvl(h.getPresentIllness()) + "\n\n"
            + "### Past History\n\n" + nvl(h.getPastHistory()) + "\n\n"
            + "## O. Objective\n\n"
            + "### Lab Results\n\n" + nvl(h.getLabResults()) + "\n\n"
            + "### Imaging / Study Results\n\n" + nvl(h.getImagingResults()) + "\n\n"
            + "## A. Assessment\n\n" + nvl(h.getDiagnosis()) + "\n\n"
            + "## P. Plan\n\n" + nvl(h.getPlan()) + "\n\n"
            + "## Free Text\n\n" + nvl(h.getFreeText()) + "\n";
    }

    private static String toText(HistoryBean h) {
        return "EMR Record: " + nvl(h.getId()) + "\n"
            + "Patient ID: " + nvl(h.getPatientId()) + "\n"
            + "Doctor ID: " + nvl(h.getEmployeeId()) + "\n"
            + "Vitals: BP " + h.getBpSystolic() + "/" + h.getBpDiastolic()
            + ", HR " + nvl(h.getHr()) + ", RR " + nvl(h.getRr()) + ", SpO2 " + nvl(h.getSpo2())
            + ", Temp " + h.getTemp() + ", Height " + h.getHeight() + ", Weight " + h.getWeight() + "\n\n"
            + "[Chief Complaint]\n" + nvl(h.getChiefComplaint()) + "\n\n"
            + "[Present Illness]\n" + nvl(h.getPresentIllness()) + "\n\n"
            + "[Past History]\n" + nvl(h.getPastHistory()) + "\n\n"
            + "[Lab Results]\n" + nvl(h.getLabResults()) + "\n\n"
            + "[Imaging Results]\n" + nvl(h.getImagingResults()) + "\n\n"
            + "[Diagnosis]\n" + nvl(h.getDiagnosis()) + "\n\n"
            + "[Plan]\n" + nvl(h.getPlan()) + "\n\n"
            + "[Free Text]\n" + nvl(h.getFreeText()) + "\n";
    }

    private static String readJsonString(String json, String key) {
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"", Pattern.DOTALL);
        Matcher matcher = pattern.matcher(json);
        return matcher.find() ? unescapeJson(matcher.group(1)) : "";
    }

    private static String q(String value) {
        return "\"" + escapeJson(value) + "\"";
    }

    private static String escapeJson(String value) {
        if (value == null) return "";
        return value
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\r", "\\r")
            .replace("\n", "\\n")
            .replace("\t", "\\t");
    }

    private static String unescapeJson(String value) {
        StringBuilder sb = new StringBuilder();
        boolean escaping = false;
        for (int i = 0; i < value.length(); i++) {
            char ch = value.charAt(i);
            if (escaping) {
                switch (ch) {
                    case 'n': sb.append('\n'); break;
                    case 'r': sb.append('\r'); break;
                    case 't': sb.append('\t'); break;
                    case '"': sb.append('"'); break;
                    case '\\': sb.append('\\'); break;
                    default: sb.append(ch); break;
                }
                escaping = false;
            } else if (ch == '\\') {
                escaping = true;
            } else {
                sb.append(ch);
            }
        }
        return sb.toString();
    }

    private static String nvl(String value) {
        return value == null ? "" : value;
    }
}
