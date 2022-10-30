public class APICustomException extends Exception {
    
    private Integer errorCode;
    private String message;
    private String sourceError;
    
    public APICustomException(Integer errorCode, String message, String sourceError){
        this.errorCode = errorCode;
        this.message = message;
        this.sourceError = sourceError;
    }
    public Integer getErrorCode(){
        return this.errorCode;
    }
    public void setErrorCode(Integer errorCode){
        this.errorCode = errorCode;
    }
    public override String getMessage(){
        return message;
    }
    public override void setMessage(String message){
        this.message = message;
    }
    public String getSourceError(){
        return sourceError;
    }
    public void setSourceError(String sourceError){
        this.sourceError = sourceError;
    }
}