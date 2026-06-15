package com.emrBean;

public class MessageBean {
    private String id;          // varchar(10)
    private String sender;      // varchar(255)
    private String receiver;    // varchar(255)
    private String content;     // longtext
    private String messageFile; // varchar(255)
    private String state;       // varchar(45)
    private String entryDate;   // timestamp
    private String employeeId;  // varchar(10)

    // Getter & Setter
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getSender() { return sender; }
    public void setSender(String sender) { this.sender = sender; }
    public String getReceiver() { return receiver; }
    public void setReceiver(String receiver) { this.receiver = receiver; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getMessageFile() { return messageFile; }
    public void setMessageFile(String messageFile) { this.messageFile = messageFile; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getEntryDate() { return entryDate; }
    public void setEntryDate(String entryDate) { this.entryDate = entryDate; }
    public String getEmployeeId() { return employeeId; }
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
}