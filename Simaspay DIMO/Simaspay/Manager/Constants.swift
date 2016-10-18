// MARK: Keys
let TXNNAME = "txnName"
let SERVICE = "service"
let SOURCEMDN = "sourceMDN"
let SOURCEPIN = "sourcePIN"
let mPIN_STRING = "authenticationString"
let SIMASPAY_ACTIVITY = "isSimaspayActivity"
let SOURCE_APP_TYPE_KEY = "apptype"
let SOURCE_APP_TYPE_VALUE = "iOS"
let SOURCE_APP_VERSION_KEY = "appversion"
let SOURCE_APP_OSVERSION_KEY = "appos"
let VERSION = "version"
let CATEGORY = "category"
let ACTIVATION_OTP = "otp"
let MFATRANSACTION = "mfaTransaction"
let ACTIVATION_NEWPIN = "activationNewPin"
let ACTIVATION_CONFORMPIN = "activationConfirmPin"
let MFAOTP = "mfaOtp"
let PARENTTXNID = "parentTxnID"
let SCTL_ID = "sctlId"

//MARK: Image key
let SIMASPAY_CONFIRM = "Confirm"
// MARK: Category
let CATEGORY_CONTACTUS = "category.ContactUsfile"

// MARK: TXNName Type
let TXN_GETPUBLC_KEY = "GetPublicKey"
let TXN_LOGIN_KEY = "Login"
let TXN_GetThirdPartyData = "GetThirdPartyData"
let TXN_INQUIRY_ACTIVATION = "Activation"
let TXN_RESENDOTP = "ResendOtp"

// MARK: Service
let SERVICE_ACCOUNT = "Account"
let SERVICE_PAYMENT = "Payment"

// MARK: UserDefault
let SIMASPAY_PUBLIC_KEY = "simasPayPublicKey"

// MARK: others
let ACTIVITY_STATUS = "true"
let INQUIRY  = "Inquiry"

// MARK: RESPONSE CODE
let SIMASPAY_LOGIN_FAILED_CODE = "11"
let SIMASPAY_LOGIN_SUCCESS_CODE = "630"
let SIMASPAY_ACTIVATION__INQUERY_SUCCESS_CODE = "2040"
let SIMASPAY_ACTIVATION__CONFIRMATION_SUCCESS_CODE = "52"
let SIMASPAY_ACTIVATION__CONFIRMATION_SUCCESS_CODE1 = "2032"

// MARK: Account Roles
let SIMASPAY_LOGIN_AGENT_TYPE = "2"
let SIMASPAY_LOGIN_REGULAR_TYPE = "true"

//MARK: opration
let SERVICE_WALLET = "Wallet"
let TXN_RESEND_MFAOTP = "ResendMFAOTP"

/*
#define SIMASPAY_ACTIVITY @"isSimaspayActivity"


#define SIMOBI @"simobi"
#define INSTITUTION_ID @"institutionID"

#define AMOUNT @"amount"
#define FROM_DATE @"fromDate"
#define TO_DATE @"toDate"
#define PAGENUMBER @"pageNumber"
#define mPIN_STRING @"authenticationString"


#define SOURCEPINTEXT @"sourcePINText"
#define SOURCENAME @"sourceName"
#define SOURCEPOCKETCODE @"sourcePocketCode"
#define DEST_BANK_CODE @"destBankCode"
#define MFAOTP @"mfaOtp"
#define DESTPOCKETCODE @"destPocketCode"
#define TRANSFERID @"transferID"

#define DESTACCOUNTNUMBER @"destAccountNo"
#define DESTBANKACCOUNT @"destBankAccount"
#define BILLNO @"billNo"
#define DENOM_CODE @"denomCode"
#define BILLERCODE @"billerCode"
#define PAYMENT_MODE @"paymentMode"

#define ACTIVATION_CONFORMPIN @"activationConfirmPin"
#define ACTIVATION_OTP @"otp"
#define CHANGEPIN_NEWPIN @"newPIN"
#define CHANGEPIN_NEWPIN_TEXT @"newPINText"
#define CHANGEPIN_CONFIRMPIN @"confirmPIN"
#define CHANGEPIN_CONFIRMPIN_Text @"confirmPINText"
#define TRANSFERID @"transferID"

#define PARTNETCODE @"partnerCode"
#define CONFIRMED @"confirmed"
#define OTP @"otp"
#define DESTMDN @"destMDN"
#define FULL_NAME @"fullName"
#define COMPANYID @"companyID"
#define POCKETCODE @"2"
#define CARDPAN @"cardPan"

#define PAYMENT_FULLAMOUNT @"FullAmount"

#define IS_LOGIN @"isLogIN"

#define KTP_Validation_Until @"ktpValidUntil"
#define KTP_Mother_Maiden_Name @"subMothersMaidenName"
#define KTPID @"ktpId"
#define KTP_LINE1 @"ktpLine1"
#define KTP_RT @"ktpRT"
#define KTP_RW @"ktpRW"
#define KTP_Zipcode @"ktpZipCode"
#define KTP_City @"ktpCity"
#define KTP_State @"ktpState"
#define KTP_District @"ktpRegionName"
#define KTP_Sub_District @"ktpSubState"
#define KTP_LifeTime @"ktpLifetime"

#define Domestic_Identity @"domesticIdentity"
#define LINE1 @"addressLine1"
#define RT @"RT"
#define RW @"RW"
#define STATE @"state"
#define SUB_STATE @"subState"
#define CITY @"city"
#define ZIPCODE @"zipCode"
#define REGION_NAME @"regionName"

#define  WORK @"work"
#define INCOME @"income"
#define Goal_Open_Account @"goalOfOpeningAccount"
#define SOURCE_OF_FUNDS @"sourceOfFunds"
#define EMAIL @"email"
#define OTHERS @"others"
#define PRODUCT_DESIRED  @"productDesired"

#define KTP_DOCUMENT @"ktpDocument"
#define SUBSCRIBER_FOR_DOCUMENT @"subscriberFormDocument"
#define SUPPORTING_DOCUMENT @"supportingDocument"

#define QR_PAYMENT @"QRPayment"
#define Transaction_ID @"transactionId"


#define SUB_FIRST_NAME @"subFirstName"
#define SUB_DOB @"dob"


#define SOURCE_APP_TYPE_KEY @"apptype"
#define SOURCE_APP_TYPE_VALUE @"iOS"

#define SOURCE_APP_VERSION_KEY @"appversion"

#define SOURCE_APP_OSVERSION_KEY @"appos"




/*  ##########################      SIMASPAY SERVICE CODES   ##########################*/


#define SIMAPAY_AGENT_REGULAR_BALANCE_CODE @"4"
#define SIMAPAY_AGENT__BALANCE_CODE @"274"


#define SIMASPAY_LOGIN_FAILED_CODE @"11"
#define SIMASPAY_LOGIN_SUCCESS_CODE @"630"

#define SIMASPAY_ACTIVATION_RESEND_OTP_SUCCESS_CODE @""
#define SIMASPAY_ACTIVATION__INQUERY_SUCCESS_CODE @"2040"


#define SIMASPAY_KTP_VALIDATION_SUCESS @"2126"
#define SIMASPAY_AGENT_REGISTRATION_SUCESS @"624"

#define SIMASPAY_CAHSIN_CASHOUT_INQUERY_SUCCESS @"72"
#define SIMASPAY_CAHSIN_CONFIRMATION_SUCCESS @"296"
#define SIMASPAY_CAHSOUT_CONFIRMATION_SUCCESS @"298"

#define DownloadTransactionHistory_Code @"2051"


#define SUBCRIBER_CLOSING_INQUERY_SUCCESS @"2128"
#define SUBCRIBER_CLOSING_INQUERY_FAILED @"2132"
#define SUBCRIBER_CLOSING_CONFIRMATION_SUCCESS @"2130"


#define SIMAPAY_SUCCESS_ACCOUNT_TRANSACTION_CODE @"67"
#define SIMAPAY_TRANSACTION_HISTORY_CODE @"39"
#define SIMAPAY_NO_TRANSACTION_HISTORY_CODE @"38"

#define SIMAPAY_SUCCESS_PURCHASE_CODE @"2030"
#define SIMAPAY_SUCCESS_PAYMENT_CODE @"653"

#define SIMAPAY_SUCCESS_REFERRAL_CODE @"2133"

#define SIMAPAY_SUCCESS_CHANGEPIN_CODE @"26"
#define SIMAPAY_SUCCESS_CHANGEPIN_INQUERY_CODE @"2039"

#define SIMASPAY_LOGIN_EXPIRE_CODE @"631"

#define SIMASPAY_RESEND_OTP_SUCESS @"2171"
#define SIMASPAY_RESEND_OTP_FAILED @"2172"
#define SIMASPAY_RESEND_OTP_LIMIT_REACHED @"2173"

#define SIMOBI_SELFBANK_TRANSFER_INQ_SUCCESSCODE @"72"
#define SIMOBI_SELFBANK_TRANSFER_CONFIRM_SUCCESSCODE @"703"
#define SIMOBI_LAKU_IBT_TRANSFER_CONFIRM_SUCCESSCODE @"81"
#define SIMOBI_LAKU_LAKU_TRANSFER_CONFIRM_SUCCESSCODE @"293"
#define SIMOBI_TRANSFER_LAKU_CONFIRM_SUCCESSCODE @"305"
#define SIMOBI_TRANSFER_UANGKU_CONFIRM_SUCCESSCODE @"2176"

#define SIMOBI_OTHERBANK_TRANSFER_SUCCESSCODE @"72"
#define SIMOBI_PAYMENT_SUCCESSCODE @"713"
#define SIMOBI_PURCHASE_SUCCESSCODE @"660"

#define SIMOBI_BILLINQUIRY_CODE @"2021"

#define FlashIS_User_Key_SuccessCode @"2103"
#define FlashIS_Inquery_SuccessCode @"2109"
#define FlashIS_Confirmation_SuccessCode @"2111"

/*  ##########################      SIMASPAY SERVICE CODES   ##########################*/

/*  ##########################      SIMASPAY OPERATIONS   ##########################*/


#define SERVICE_BANK @"Bank"
#define SERVICE_ACCOUNT @"Account"

#define SERVICE_PURCHASE @"Shopping"
#define SERVICE_PURCHASE_AIRTIME @"Buy"
#define SERVICE_AGENT "AgentServices"



#define TXN_SUBSCRIBER_KTP_VALIDATION @"SubscriberKTPValidation"
#define TXN_SUBSCRIBER_KTP_REGISTRATION @"SubscriberRegistration"

#define AGENT_CASHIN_INQUERY @"CashInInquiry"
#define AGENT_CASHIN_CONFIRMATION @"CashIn"

#define  TXN_CASHOUT_INQUERY @"CashOutInquiry"
#define  TXN_CASHOUT_CONFIRMATION @"CashOut"

#define TXN_RESEND_MFAOTP @"ResendMFAOTP"

#define TXN_PRODUCT_REFERRAL @"ProductReferral"

#define SUBCRIBER_CLOSING_INQUERY @"SubscriberClosingInquiry"
#define SUBCRIBER_CLOSING_CONFIRMATION @"SubscriberClosing"

#define TXN_INQUIRY_PURCHASE @"PurchaseInquiry"
#define TXN_CONFIRM_PURCHASE @"Purchase"
#define TXN_INQUIRY_PURCHASE_AIRTIME @"AirtimePurchaseInquiry"
#define TXN_CONFIRM_PURCHASE_AIRTIME @"AirtimePurchase"

#define TXN_INQUIRY_PAYMENT @"BillPayInquiry"
#define TXN_CONFIRM_PAYMENT @"BillPay"
#define TXN_INQUIRY_SELFBANK @"TransferInquiry"
#define TXN_INQUIRY_UANGKU @"TransferToUangkuInquiry"
#define TXN_CONFIRM_UANGKU @"TransferToUangku"
#define TXN_CONFIRM_SELFBANK @"Transfer"
#define TXN_INQUIRY_OTHERBANK @"InterBankTransferInquiry"
#define TXN_CONFIRM_OTHERBANK @"InterBankTransfer"
#define TXN_INQUIRY_CHANGEMPIN @"ChangePIN"
#define TXN_INQUIRY_ACTIVATION @"Activation"
#define TXN_ACCOUNT_BALANCE @"CheckBalance"
#define TXN_ACCOUNT_HISTORY @"History"
#define TXN_REGISTRATION @"GetRegistrationMedium"
#define TXN_RESETPIN @"ResetPinByOTP"
#define TXN_REACTIVATION @"Reactivation" //SubscriberReactivation Reactivation
#define TXN_BILLINQUIRY @"BillInquiry"

#define TXN_DownLoad_History_PDF @"DownloadHistoryAsPDF"

#define TXN_GetThirdPartyDataLocation @"GetThirdPartyLocation"
#define TXN_GetUserKey @"GetUserAPIKey"
#define TXN_FlashIz_BillPay_Inquiry @"QRPaymentInquiry"
#define TXN_FlashIz_BillPay_Confirmation @"QRPayment"

#define CATEGORY_BANK_CODES @"category.bankCodes"

#define CATEGORY_REFRRRAL @"category.product_referral"
#define CATEGORY_PURCHASE @"category.purchase"
#define CATEGORY_PAYMENTS @"category.payments"
#define CATEGORY_PROVIENCE @"category.province"
#define CATEGORY_WORK @"category.work"
#define CATEGORY_PROVIENCE @"category.province"

#define REGIONAME @"regionName"

/*  ##########################      SIMASPAY OPERATIONS   ##########################*/

/*  ##########################      SIMASPAY PLIST KEYS   ##########################*/

#define OTPNotificationKey @"com.smiaspay.OTPNotificationKey"

#define SIMASPAY_PROVIENCE_DATA @"simasProvienceData"
#define SIMASPAY_LOGIN_DATA @"simasPayLoginResponse"
#define WORK_LIST @"worklistdata"

#define AGENT_KTP_VALIDATION_RESPONSE @"agentKTPValdationResonse"
/*  ##########################      SIMASPAY PLIST KEYS   ##########################*/



/*
 * Image Keys
 */

#define ROOTVIEW_LOGIN @"RootView_Login"
#define ROOTVIEW_ACTIVATION @"RootView_Activation"

#define MAINMENU_PURCHASE @"MainMenu_Purchase"
#define MAINMENU_PAYMENT @"MainMenu_Payment"
#define MAINMENU_ACCOUNT @"MainMenu_Transfer"
#define MAINMENU_TRANSFER @"MainMenu_Account"

#define ACCOUNT_BALANCE @"Balance"
#define ACCOUNT_HISTORY @"Transaction"
#define ACCOUNT_CHANGEPIN @"Change mPin"
#define ACCOUNT_LANGUAGE @"Language"

#define TRANSFER_BANKSINARMAS @"Transfer_BankSinarmas"
#define TRANSFER_OTHERBANK @"Transfer_OtherBank"


#define SIMOBI_CANCEL @"Cancel"
#define SIMOBI_OK @"Ok"



/*
 * Text Keys
 */

#define PHONE @"phone"
#define MPIN @"mPin"
#define ACTIVATION__OTP @"activation_Otp"
#define ACTIVATION_REENTER_PIN @"activation_rePin"
#define TRANSFER_ACCOUNT @"transfer_Account"
#define TRANSFER_AMOUNT @"transfer_Amount"
#define TRANSFER_MPIN @"transfer_mPin"
#define CHANGEPIN_OLD_MPIN @"changePin_Oldpin"
#define CHANEPIN_NEW_MPIN @"changePin_Newpin"
#define CHANEPIN_REENTER_NEW_MPIN @"changePin_rePin"
#define LANGUAGE @"language"
#define PURCHASE @"purchase"
#define PAYMENT @"payment"
#define TRANSFER @"transfer"
#define ACCOUNT @"account"
#define ACCOUNT_TYPE @"accountType"
#define PAYBYQR @"paybyQR"
#define ACTIVATION @"activation"
#define CHANGELANGUAGE @"changelanguage"
#define BALANCE @"balance"
#define TRANSACTION @"transaction"
#define CHANGEPIN @"changepin"
#define SELF_BANK @"selfBank"
#define OTHER_BANK @"otherBank"
#define CONFIRM @"Confirm"
#define SUBMIT @"submit"
#define CANCEL @"cancel"
#define NEXT @"next"

#define OKBUTTON @"ok"
#define CONTACTUS @"contactus"

#define PAYMENTCATEGORY @"paymentcategory"
#define BILLER @"biller"
#define PAYMENTPRODUCT @"paymnetproduct"
#define PURCHASECATEGORY @"purchasecategory"
#define PURCHASEPRODUCT @"purchaseproduct"
#define CONFIRMPIN @"confirmPIN"
#define NEWPIN @"newPIN"
#define RESET_MPIN_TITLE @"ResetMPIN"
#define REACTIVATION_TITLE @"Reactivation"

#define REQUEST_TIME_OUT_ERROR @"requestTimeOut"
#define REQUEST_TIME_OUT_ERROR_FINANCE @"financeRequestTimeOut"


/*
 * English Text
 */
#define ENGLISH_PHONENUMBER_TEXT @"enter your phone number"
#define ENGLISH_MPIN_TEXT @"enter your mPin"
#define ENGLISH_OTP_TEXT @"enter your verification code(OTP)"
#define ENGLISH_REENTER_MPIN_TEXT @"re-enter your mPin"
#define ENGLISH_TRANSFER_ACCOUNT_TEXT @"account number"
#define ENGLISH_TRANSFER_AMOUNT_TEXT @"amount"
#define ENGLISH_TRANSFER_MPIN_TEXT @"mPIN"

#define ENGLISH_CHANGEPIN_OLDMPIN_TEXT @"enter your old mPin"
#define ENGLISH_TRANSFER_NEWMPIN_TEXT @"enter your new mPin"
#define ENGLISH_TRANSFER_REENTER_MPIN_TEXT @"re-enter your new mPin"

#define ENGLISH_CHOSE_LANGUAGE_TEXT @"choose your language"
#define ENGLISH_PURCHASE_TEXT @"Purchase"
#define ENGLISH_PAYBYQR_TEXT @"Pay by QR"
#define ENGLISH_PAYMENT_TEXT @"Payment"
#define ENGLISH_TRANSFER_TEXT @"Transfer"
#define ENGLISH_ACCOUNT_TEXT @"Account"

#define ENGLISH_ACTIVATION_TEXT @"Activation"
#define ENGLISH_LANGUAGE_TEXT @"Language"
#define ENGLISH_BALNCE_TEXT @"Balance"
#define ENGLISH_TRANSACTION_TEXT @"History"
#define ENGLISH_CHANGEPIN_TEXT @"change mPIN"

#define ENGLISH_SELFBANK_TEXT @"Bank Sinarmas"
#define ENGLISH_OTHERBANK_TEXT @"Other Bank"

#define ENGLISH_CONFIRM_TEXT @"Confirm"
#define ENGLISH_CANCEL_TEXT @"Cancel"
#define ENGLISH_SUBMIT_TEXT @"Submit"
#define ENGLISH_OK_TEXT @"Ok"
#define ENGLISH_NEXT_TEXT @"Next"

#define ENGLISH_CONTACTUS_TEXT @"Contact us"

#define ENGLISH_PURCHASE_CATEGORY_TEXT @"Prepaid Category"
#define ENGLISH_BILLER_TEXT @"Biller Name"
#define ENGLISH_PURCHASE_PRODUCT_TEXT @"Prepaid Type"
#define ENGLISH_PAYMENT_CATEGORY_TEXT @"Payment Category"
#define ENGLISH_PAYMENT_PRODUCT_TEXT @"Payment Type"

#define ENGLISH_CONFIRMPIN_TEXT @"Confirm New mPin"

#define ENGLISH_NEWMPIN_TEXT @"New mPin"

#define ENGLISH_RESET_PIN_TEXT @"Reset mPIN"

#define ENGLISH_REACTIVATION_TEXT @"Reactivation"



#define ENGLISH_TIME_OUT_ERROR @"Dear customer, currently you are not connected to Bank Sinarmas server. Please try again later."
#define ENGLISH_TIME_OUT_ERROR_FINANCE @"Please wait while your transaction is being processed. Please check your transaction history to see this transaction status."

/*
 *Bahasa Text
 */

#define BAHASA_PHONENUMBER_TEXT @"masukkan nomor telepon anda"
#define BAHASA_MPIN_TEXT @"masukkan mPin anda"
#define BAHASA_OTP_TEXT @"masukkan kode verifikasi(OTP)"
#define BAHASA_REENTER_MPIN_TEXT @"masukkan kembali mPin baru anda"
#define BAHASA_TRANSFER_ACCOUNT_TEXT @"nomor rekening"
#define BAHASA_TRANSFER_AMOUNT_TEXT @"jumlah"
#define BAHASA_TRANSFER_MPIN_TEXT @"mPin"

#define BAHASA_CHANGEPIN_OLDMPIN_TEXT @"masukkan mPin lama anda"
#define BAHASA_TRANSFER_NEWMPIN_TEXT @"masukkan mPin baru anda"
#define BAHASA_TRANSFER_REENTER_MPIN_TEXT @"masukkan kembali mPin baru anda"

#define BAHASA_CHOOSELANGUAGE_TEXT @"pilih bahasa"
#define BAHASA_PURCHASE_TEXT @"Pembelian"
#define BAHASA_PAYBYQR_TEXT @"Bayar Pakai QR"
#define BAHASA_PAYMENT_TEXT @"Pembayaran"
#define BAHASA_TRANSFER_TEXT @"Kirim"
#define BAHASA_ACCOUNT_TEXT @"Rekening"

#define BAHASA_ACTIVATION_TEXT @"Aktivasi"
#define BAHASA_LANGUAGE_TEXT @"Bahasa"
#define BAHASA_BALNCE_TEXT @"Saldo"
#define BAHASA_TRANSACTION_TEXT @"Transaksi"
#define BAHASA_CHANGEPIN_TEXT @"ganti mPIN"

#define BAHASA_SELFBANK_TEXT @"Bank Sinarmas"
#define BAHASA_OTHERBANK_TEXT @"Bank Lain"

#define BAHASA_CONFIRM_TEXT @"Konfirmasi"
#define BAHASA_CANCEL_TEXT @"Batal"
#define BAHASA_SUBMIT_TEXT @"Kirim"
#define BAHASA_OK_TEXT @"Ok"
#define BAHASA_NEXT_TEXT @"Lanjut"

#define BAHASA_CONTCTUS_TEXT @"Kontak Kami"

#define BAHASA_PURCHASE_CATEGORY_TEXT @"Kategori Prabayar"
#define BAHASA_BILLER_TEXT @"Nama Biller"
#define BAHASA_PURCHASE_PRODUCT_TEXT @"Tipe Prabayar"
#define BAHASA_PAYMENT_CATEGORY_TEXT @"Kategori Pembayaran"
#define BAHASA_PAYMENT_PRODUCT_TEXT @"Jenis Pembayaran"

#define BAHASA_CONFIRMPIN_TEXT @"Konfirmasi mPIN"
#define BAHASA_NEWMPIN_TEXT @"mPIN Baru"

#define BAHASA_RESET_PIN_TEXT @"Reset mPIN"

#define BAHASA_REACTIVATION_TEXT @"Aktivasi Ulang"




#define BAHASA_TIME_OUT_ERROR @"Nasabah yang terhormat, saat ini tidak dapat terhubung dengan server Bank Sinarmas. Silahkan coba lagi nanti."
#define BAHASA_TIME_OUT_ERROR_FINANCE @"Mohon menunggu, transaksi Anda sedang dalam proses. Periksa riwayat transaksi untuk mengetahui status transaksi Anda"

#define SHOW_INTERNET_MSG @"Tidak dapat terhubung dengan server SimasPay. Harap periksa koneksi internet Anda dan coba kembali setelah beberapa saat."

#define SHOW_NETWORK_LOST @"Koneksi jaringan hilang"


#define EULAMESSAGE @"Term and condition M-Bank Sinarmas Services\nArticle 1: Definition\nUnless defined otherwise, by:\n1.1. M-Bank Sinarmas shall mean e-banking service to carry out the financial and non-financial transactions with clearer menu display where the application shall be downloaded firstly by using cellular phone handset/tablet computer as well as 3G/GPRS/WIFI technology.\n1.2 Bank shall mean PT. Sinarmas (Persero) Tbk, having its domicile and head office in Jakarta\n1.3 3G/GPRS/WIFI Technology shall mean the data package delivery and receive technology made available by the cellular network/telecommunication service provider.\n1.4 Customer shall mean individual owner of Bank Sinarmas ATM card.\n1.5 M-Bank Sinarmas service can be linked to Bank Sinarmas saving account or Bank Sinarmas current account with currency IDR.\nArticle 2: Terms of Simobi Bank Sinarmas registration\n2.1. Already having Bank Sinarmas giro account or Bank Sinarmas savings account.\n2.2. Customer must do Simobi Bank Sinarmas Registration from Bank Sinarmas office or ATM Bank Sinarmas. Once registration successful, customer will received sms with 8 digit OTP (one time password) to be used for activation.\n2.3. Simobi Bank Sinarmas application service can be downloaded from www.banksinarmas.com\n2.4. Have read and accepting the Terms and Conditions of Simobi Bank Sinarmas.\nArticle 3: Conditions of Simobi Bank Sinarmas Use\n3.1  Customer must do activation prior to be able using the Simobi Bank Sinarmas services.\n3.2  The Customer may use Simobi Bank Sinarmas service to obtain information or carry out banking transaction already determined.\n3.3  Simobi Bank Sinarmas service can be used by registering all cellular telephone available in Indonesia.\n3.4  Simobi Bank Sinarmas service can only be used in 1 cellular telephone number (MSISDN) for one account.\n3.5  For all financial transaction from Simobi Bank Sinarmas will be challenged and authenticated by mPIN.\n3.6  Simobi Bank Sinarmas mPIN is created while activation process by customer.\n3.7  When implementing the transaction, the Customer shall:\n• Ensure the completeness and correctness of data on transaction mentioned. All consequences arising from the default, incompleteness and or error by the Customer shall fully become the Customer’s responsibility.\n• Enter Simobi Bank Sinarmas mPIN while making transaction.\n3.8  Every instruction provided by the Customer through Simobi Bank Sinarmas service cannot be canceled.\n3.9  Every instruction already provided by the Customer according to the Terms & Conditions of this service shall be valid proof, unless proven otherwise and the Bank has no obligation to examine such validity.\n3.10  The Bank shall be entitled to neglect the Customer's instruction, if:\na. Balance in Customer's account is insufficient.\nb. There is indication of crime.\n3.11  All consequences arising as the consequence of the abuse of Simobi Bank Sinarmas shall become full responsibility of the Customer and the Customer hereby keeps harmless the Bank from all claims potentially arising in any terms and from any parties.\n3.12 As the proof of transaction implementation, the Customer will obtain the transaction number proof at every end of transaction via SMS, as long as the Customer's cellular phone message box still allows or there is no communication network interference. \n3.13 At its own consideration, the Bank shall be entitled to change the transaction limit. Such change shall bind the Customer sufficiently by the notification according to the prevailing provisions.\nArticle 4: Simobi Bank Sinarmas password\n4.1  The Customer shall secure his mPIN. In this respect, the Customer shall not:\na. Notify the mPIN to the others;\nb. Save mPIN in the cellular telephone memory or other saving facilities allowing the other parties to know it;\nThe Customer shall also replace the mPIN periodically.\n4.2  All consequences arising due to the abuse of mPIN shall fully become the Customer’s responsibility and the Customer hereby keeps harmless the Bank from all claims potentially arising in any terms and from any parties.\n4.3  If the Customer wrongly enters the mPIN for 3 (three) times consecutively, then the application will be automatically blocked. To reactivate such application, the Customer shall visit the provided Bank Sinarmas office or ATM to do mPIN reset.\nArticle 5: Cessation of Access to Simobi Bank Sinarmas service\n5.1  Simobi Bank Sinarmas service will be ceased by the Bank if:\na. There is written request from the Customer.\nb. The customer closes all accounts accessible via Simobi Bank Sinarmas service.\nc. Obliged by the prevailing legislation and or court’s judgment.\nArticle 6: Miscellany\nFor the problem relating to cellular phone number, GPRS/3G network, invoice for use of GPRS/3G, SMS charge, and value added service of GPRS/3G, the Customer shall directly contact the operator of the relevant GPRS/3G cellular mobile network/ telecommunication service. While for the problem on service, the Customer may contact the Bank Sinarmas CARE 500 153.\nThe Bank may change these Terms and Conditions according to the need. The change will be binding to the Customer sufficiently by notification according to the provisions applicable to the Bank.\nThe Customer shall comply with the terms applicable to the Bank including but not limited to the General Conditions of Account Opening, Special Conditions of Giro Account Opening, or Special Conditions of Savings Account Opening.\nThe powers of attorney granted relating to this service shall be a valid power of attorney that will not expire as long as the Customer still uses Simobi Bank Sinarmas service or there is still other obligation of the Customer to the bank.\nThe Customer shall keep harmless the Bank from all claims, in case the Bank fails to implement the Customer’s instruction partly or entirely due to any events or causes beyond the control or capability of the Bank such as computer virus interference, web browser, dysfunction system or transmission, electricity failure, telecommunication failure or government policy, as well as any other events or causes beyond the control or capability of the Bank."

/****************************************************************************************/

//115.112.108.203:8443
//simobi.banksinarmas.com
//dev.simobi.banksinarmas.com
//175.101.5.69:8443


#define TERMS_CONDITIONS @"https://www.banksinarmas.com/PersonalBanking/IB.do?action=terms"


//  ##########################      DEV   ##########################
/*
 #define SIMASPAY_URL @"https://175.101.5.72:8444/webapi/sdynamic?channelID=7&mspID=1"
 #define FLASHiZ_SERVER  ServerURLDev
 #define DOWNLOAD_PDF_URL @"https://175.101.5.72:8444/webapi/"
 */
//  ##########################      DEV   ##########################

//  ##########################      QA   ##########################
/*
 #define SIMASPAY_URL @"https://175.101.5.72:8444/webapi/sdynamic?channelID=7&"
 #define FLASHiZ_SERVER  ServerURLDev
 #define DOWNLOAD_PDF_URL @"https://175.101.5.72:8444/webapi/"
 */
//  ##########################      QA   ##########################

//  ##########################      UAT   ##########################
/*
 #define SIMASPAY_URL @"https://simaspaydev.banksinarmas.com/webapi/sdynamic?channelID=7&mspID=1"
 #define FLASHiZ_SERVER  ServerURLUat
 #define DOWNLOAD_PDF_URL @"https://simaspaydev.banksinarmas.com/webapi/"
 */
//  ##########################      UAT   ##########################

//  ##########################      AWS   ##########################

#define SIMASPAY_URL @"https://54.255.194.95:8443/webapi/sdynamic?channelID=7&mspID=1"
//#define SIMOBI_URL @"https://staging.dimo.co.id:8470/webapi/sdynamic?channelID=7&"
#define FLASHiZ_SERVER  ServerURLUat
#define DOWNLOAD_PDF_URL @"https://54.255.194.95:8443/webapi/"

// ##########################      AWS   ##########################

//  ##########################      PROD   ##########################*/
/*
 #define SIMOBI_URL @"https://simobi.banksinarmas.com/webapi/sdynamic?channelID=7&"
 #define FLASHiZ_SERVER @"https://my.flashiz.co.id"
 #define FLASHiZ_SERVER  ServerURLLive
 */
//  ##########################      PROD   ##########################
