public enum AdjarabetCoreStatusCode: Int, Codable {
    case STATUS_SUCCESS = 10  // Operation was successful
    case WRONG_REQUEST = 99 //Received request had invalid structure
    case FIELD_LIMIT_REACHED = 100 // Value specified in the field has reached its limit
    case FIELD_MIN_MAX_NOT_MATCHED = 101 // Value specified in the field does not meet Min / Max requirements
    case FIELD_FORMAT_NOT_MATCHED = 102 //Value specified in the field does not meet its format requirements
    case FIELD_IS_EMPTY = 103 // Field can`t be empty
    case PATTERN_IS_NOT_MATCHED = 104 // Value specified in the field does not meet its pattern requirements
    case COUNTRY_NOT_SUPPORTED = 105 // Specified country is not supported by the system
    case AGE_LIMIT_NOT_MATCHED = 106 // Specified age of the user does not meet system defined requirements
    case ID_DOCUMENT_IS_MISSING = 107 // ID Document of the user must be specified
    case MAX_POSSIBLE_REG_PER_IP_REACHED = 108 //IP has reached its limit for number of registrations allowed
    case UNABLE_TO_SAVE_ID_DOC = 109 // ID Document of the user could not be saved
    case UNABLE_TO_ASSIGN_ACCOUNT_TO_USER = 110
    case GENERIC_FAILED_ERROR = 111
    case MISSING_PARAMETERS = 112
    case USER_WITH_GIVEN_AUTH_CREDENTIALS_NOT_FOUND = 113
    case OTP_REQUEST_LIMIT_REACHED = 114
    case UNABLE_TO_SEND_OTP_TEL_IS_MISSING = 115
    case UNABLE_TO_SEND_SMS_CODE_OTP_IS_ENABLED = 116
    case FAILED_TO_SEND_OTP = 117
    case OTP_IS_SENT = 118
    case OTP_NOT_FOUND = 119
    case OTP_IS_NOT_ENABLED = 120
    case UNABLE_TO_GENERATE_OTP = 121
    case OTP_IS_REQUIRED = 122
    case LAST_ACCESS_FROM_DIFFERENT_IP = 123
    case IP_IS_BLOCKED = 124
    case ACCOUNT_NOT_FOUND = 125
    case SESSION_NOT_FOUND = 126
    case OLD_AND_NEW_VALUES_MATCH_ERROR = 127
    case CONTACT_DETAILS_NOT_ASSIGNED = 128
    case CONTACT_DETAIL_NOT_MATCHED = 129
    case UNABLE_TO_ENABLE_OTP_TEL_IS_MISSING = 130
    case ACCOUNT_IS_BLOCKED = 131
    case OTP_IS_OFF = 132
    case USER_HAS_GIVEN_ID_DOC = 133
    case OTP_IS_ENABLED = 134
    case USERS_DOCUMENT_NOT_FOUND = 135
    case DOCUMENT_PHOTO_ALREADY_EXISTS = 136
    case PROVIDER_NOT_FOUND = 137
    case ACCESS_DENIED = 138
    case WRONG_HASH = 139
    case ACCESS_GRANTED = 140
    case USER_IS_SELF_EXCLUDED = 141
    case WRONG_DATES = 142
    case CAN_NOT_BE_NEGATIVE = 143
    case MUST_BE_MORE_THAN_ZERO = 144
    case CURRENCY_NOT_FOUND = 145
    case USERS_ACCOUNTS_NOT_FOUND = 146
    case TOKEN_NOT_FOUND = 147
    case TOKEN_IS_EXPIRED = 148
    case INCORRECT_USER_STATUSID = 149
    case ACCESS_DENIED_FOR_GIVEN_PROVIDER = 150
    case DUPLICATED_PROVIDERS_TRANSACTIONID = 151
    case PRIMARY_CURRENCY_NOT_FOUND = 152
    case TRANSACTION_AMOUNT_AND_LIMIT_DONT_MATCH = 153
    case INSUFFICIENT_FUNDS = 154
    case INCORRECT_TRANSACTION_ID_FORMAT = 155
    case TRANSACTION_NOT_FOUND = 156
    case TRANSACTION_STATUS_SUCCESS = 157
    case TRANSACTION_STATUS_ROLLBACK = 158
    case ACCOUNT_IS_SUSPENDED = 159
    case UNABLE_TO_GET_BALANCE = 170
    case UNABLE_TO_EXCHANGE = 171
    case TRANSACTION_ROLLBACK_TIME_EXPIRED = 172
    case UNABLE_TO_ROLLBACK_TRANSACTION = 173
    case PAYMENT_ACCOUNT_NOT_FOUND = 174
    case PAYMENT_ACCOUNT_IS_NOT_VERIFIED = 175
    case EXCHANGE_RATE_NOT_FOUND = 176
    case CARD_VERIFICATION_TRANSACTION_DOES_NOT_REQUIRE_APPROVAL = 177
    case UNIDENTIFIED_TRANSACTION_STATUS = 178
    case UNABLE_TO_CHANGE_TRANSACTION_STATUS_FROM_CURRENT_STATUS = 179
    case UNABLE_TO_CHANGE_TRANSACTION_STATUS = 180
    case TRANSACTION_STATUS_APPROVED = 181
    case TRANSACTION_STATUS_PENDING = 182
    case TRANSACTION_STATUS_REJECTED = 183
    case TRANSACTION_STATUS_FROZEN = 184
    case TRANSACTION_STATUS_CANCELED = 185
    case PROVIDER_IS_DISABLED = 186
    case FAILED_TO_VERIFY_PARAMETERS = 187
    case REGISTRATION_PROFILE_NOT_FOUND = 188
    case ORIGIN_DOMAIN_NOT_ALLOWED = 189
    case UNABLE_TO_SEND_EMAIL_VERIFICATION_EMAIL_IS_MISSING = 190
    case FIELD_NEW_VALUE_CAN_NOT_BE_LESS_THAN_CURRENT_VALUE = 191
    case TERMS_AND_CONDITION_NOT_FOUND = 192
    case USER_IS_MISSING_REGISTRATION_DOMAIN = 193
    case UNABLE_TO_ACCEPT_PROVIDED_TERMS = 194
    case USER_HAS_TO_ACCEPT_REQUIRED_TERMS = 195
    case CONTACT_CHANNEL_NOT_VERIFIED = 197
    case USER_IS_MISSING_DATE_OF_BIRTH = 198
    case CARD_VERIFICATION_TRANSACTION_CANNOT_PARTICIPATE_IN_BONUS = 199
    case CASH_TRANSACTION_CANNOT_PARTICIPATE_IN_BONUS = 201
    case BONUS_WITH_SPECIFIED_PARAMETERS_NOT_FOUND = 202
    case BONUS_IS_MISSING_ALLOWED_GAMES_LIST = 203
    case PROVIDER_SERVICE_IS_NOT_ALLOWED_TO_USE_BONUS = 204
    case BONUS_IS_EXPIRED = 205
    case UNABLE_TO_MODIFY_CORRUPTED_TRANSACTION = 206
    case INVALID_IMAGE_FILE_NAME = 207
    case STATUS_CANNOT_BE_CHANGE_TO_GIVEN_NEW_STATUS = 208
    case THIRD_PARTY_AUTH_SYSTEM_DISABLED = 209
    case THIRD_PARTY_AUTH_SYSTEM_NOT_ALLOWED = 210
    case PAYMENT_ACCOUNT_ALREADY_EXISTS = 211
    case SESSION_CHECK_WITH_EXPOSED_SESSION_ID_NOT_ALLOWED = 212
    case USER_DOES_NOT_BELONG_TO_ORIGIN_DOMAIN = 213
    case PROVIDED_TX_FEE_CAN_NOT_OVERRIDE_PROVIDERS_TX_FEES = 215
    case PROVIDER_TX_REFERENCE_ID_IS_ALREADY_SET = 216
    case PROVIDER_MIN_AMOUNT_IS_GREATER_THAN_AMOUNT = 217
    case DEPOSIT_LIMIT_REACHED = 218
    case WAGER_LIMIT_REACHED = 219
    case LOSS_LIMIT_REACHED = 220
    case TRANSACTION_TYPE_NOT_ALLOWED = 221
    case USER_HAS_ACTIVE_LIMIT_IN_DIFFERENT_CURRECNY = 222
    case VALUE_IS_ALREADY_SET = 223
    case CURRENCY_NOT_FOUND_OR_IS_VIRTUAL = 224
    case FINANCIAL_LIMIT_REACHED = 225
    case REALITY_CHECK_IS_DUE = 226
    case REALITY_CHECK_IS_NOT_DUE_YET = 227
    case STATUS_ITEM_DOES_NOT_EXISTS = 400
    case STATUS_UNABLE_TO_CHECK_ITEM = 500
}
