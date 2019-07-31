package com.kh.myhouse.admin.model.exception;

public class AdminException extends RuntimeException {
	
	public AdminException() {
		super();
	}

	public AdminException(String arg0, Throwable arg1, boolean arg2, boolean arg3) {
		super(arg0, arg1, arg2, arg3);
	}

	public AdminException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

	public AdminException(String arg0) {
		super(arg0);
	}

	public AdminException(Throwable arg0) {
		super(arg0);
	}

	

}
