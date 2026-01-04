package com.gorasr6.book.handler;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Map;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ExceptionResponse {

    private Integer businessErrorCode;
    private String businessErrorDescription;
    private String error;
    private Set<String> validationErrors;
    private Map<String, String> errors;

    public static ExceptionResponseBuilder builder() {
        return new ExceptionResponseBuilder();
    }

    public static class ExceptionResponseBuilder {
        private Integer businessErrorCode;
        private String businessErrorDescription;
        private String error;
        private Set<String> validationErrors;
        private Map<String, String> errors;

        ExceptionResponseBuilder() {
        }

        public ExceptionResponseBuilder businessErrorCode(Integer businessErrorCode) {
            this.businessErrorCode = businessErrorCode;
            return this;
        }

        public ExceptionResponseBuilder businessErrorDescription(String businessErrorDescription) {
            this.businessErrorDescription = businessErrorDescription;
            return this;
        }

        public ExceptionResponseBuilder error(String error) {
            this.error = error;
            return this;
        }

        public ExceptionResponseBuilder validationErrors(Set<String> validationErrors) {
            this.validationErrors = validationErrors;
            return this;
        }

        public ExceptionResponseBuilder errors(Map<String, String> errors) {
            this.errors = errors;
            return this;
        }

        public ExceptionResponse build() {
            return new ExceptionResponse(businessErrorCode, businessErrorDescription, error, validationErrors, errors);
        }

        public String toString() {
            return "ExceptionResponse.ExceptionResponseBuilder(businessErrorCode=" + this.businessErrorCode + ", businessErrorDescription=" + this.businessErrorDescription + ", error=" + this.error + ", validationErrors=" + this.validationErrors + ", errors=" + this.errors + ")";
        }
    }
}
