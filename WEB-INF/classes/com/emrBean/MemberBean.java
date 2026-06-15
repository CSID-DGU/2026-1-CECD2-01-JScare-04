package com.emrBean;

public class MemberBean {
	
	private String id;
	private String name;
	private String pw;
	private String email;
	private String phone;
	private String deptId;
	
	//기본생성자
	public MemberBean() {}
	public MemberBean(String id,String name, String pw, String email, String phone) {
		this.id=id;
		this.name=name;
		this.pw=pw;
		this.email=email;
		this.phone=phone;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	public void setName(String name) {
		this.name=name;
	}
	

	public void setPw(String pw) {
	    this.pw = pw;
	}

	public void setEmail(String email) {
	    this.email = email;
	}

	public void setPhone(String phone) {
	    this.phone = phone;
	}

	public void setDeptId(String deptId) {
	    this.deptId = deptId;
	}

	public String getName() {
		return name;
	}
	public String getId() {
		return id;
	}
	public String getPw() {
		return pw;
	}
	public String getEmail() {
		return email;
	}
	public String getPhone() {
		return phone;
	}

	public String getDeptId() {
		return deptId;
	}
	
}
