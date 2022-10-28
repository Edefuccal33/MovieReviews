public class IMDbAPIException extends Exception {
	private Integer errorCode;
    private String message;
    public IMDbAPIException(Integer errorCode, String message){
        this.errorCode = errorCode;
        this.message = message;
    }
    public Integer getErrorCode(){
        return this.errorCode;
    }
    public void setErrorCode(Integer errorCode){
        this.errorCode = errorCodE;
    }
    public override String getMessage(){
        return message;
    }
    public override void setMessage(String message){
        this.message = message;
    }
}