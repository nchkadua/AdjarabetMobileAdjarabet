function Server3dsApplePay(options) {
    this.merchant_id = "merchant.com.adjarabet.web";
    const ROOT_URL = "https://applepayecomm.ufc.ge";
    const merchantValidationUrl = ROOT_URL + '/applePay/validateMerchant';
    const paymentAuthorizationUrl = options.authorizationUrl;

    this.version = 6;
    this.session = null;

    this.paymentRequest = {};
    this.applicationData;

    xhrRequest = (type, url, resolve, reject) => {
        let xhr = new XMLHttpRequest();

        xhr.onload = function () {
            if (xhr.status >= 200 && xhr.status < 300) {
                resolve(JSON.parse(xhr.response));
            } else {
                reject({
                    status: xhr.status,
                    statusText: xhr.statusText
                });
            }
        };
        xhr.onerror = function () {
            reject({
                status: xhr.status,
                statusText: xhr.statusText
            });
        };

        xhr.open(type, url);
        xhr.setRequestHeader('Content-Type', 'application/json');

        return xhr;
    }

    getApplePaySession = (url) => {
        return new Promise((resolve, reject) => {
            const payload = {
                data: {
                    type: "applepay_session",
                    attributes: {
                        url: url
                    }
                }
            }

            xhrRequest('POST', merchantValidationUrl, resolve, reject).send(JSON.stringify(payload));
        });
    }

    makePayment = (payment) => {
        return new Promise((resolve, reject) => {
            const payload = {
                data: {
                    type: "payment",
                    attributes: {
                        apple_pay: {
                            token: payment.token,
                            shipping_contact: payment.shippingContact,
                            application_data: this.applicationData,
                            payment_request: this.paymentRequest
                        }
                    }
                }
            }

            xhrRequest('POST', paymentAuthorizationUrl, resolve, reject).send(JSON.stringify(payload));
        });
    }
}

Server3dsApplePay.prototype = {
    onSuccess: function (response) {
        throw 'Method onSuccess must be implemented!';
    },

    onFailure: function (response) {
        throw 'Method onFailure must be implemented!';
    },

    getPaymentRequest: function (response) {
        throw 'Method getPaymentRequest must be implemented!';
    },

    beforeBeginSession: function (e) {
        return Promise.resolve(true);
    },



    onValidateMerchant: function (e) {
        getApplePaySession(e.validationURL).then((response) => {
            this.session.completeMerchantValidation(
                JSON.parse(response.data.attributes.session)
            );
        }).catch((error) => {
            if (this.session) {
                this.session.abort();
            }
            // this.onFailure(error);
        });
    },

    onPaymentAuthorized: function (e) {
        makePayment(e.payment).then((response) => {
            if (response.code === 10) {
                this.session.completePayment(ApplePaySession.STATUS_SUCCESS);
                this.onSuccess(response);
            } else {
                this.session.completePayment(ApplePaySession.STATUS_FAILURE);
                this.onFailure(response);
            }
        }).catch((error) => {
            this.session.completePayment(ApplePaySession.STATUS_FAILURE);
            this.onFailure(error);
        });
    },


    validateRequest: function (request) {
        if (typeof request.merchantCapabilities === 'undefined') {
            request.merchantCapabilities = ['supports3DS'];
        }

        if (typeof request.supportedNetworks === 'undefined') {
            request.supportedNetworks = ["masterCard", "visa"];
        }

        if (typeof request.requiredShippingContactFields === 'undefined') {
            request.requiredShippingContactFields = ['name'];
        }

        if (typeof request.applicationData !== 'undefined') {
            this.applicationData = request.applicationData;
            request.applicationData = btoa(this.applicationData);
        }

        return request;
    },

    beginApplePayPayment: function (e) {
        e.preventDefault();

        this.getPaymentRequest(e).then((paymentRequest) => {
            this.paymentRequest = this.validateRequest(paymentRequest);

            this.session = new ApplePaySession(this.version, this.paymentRequest);

            this.session.onvalidatemerchant = this.onValidateMerchant.bind(this);
            this.session.onpaymentauthorized = this.onPaymentAuthorized.bind(this);
            this.session.oncancel = this.onFailure.bind(this);

            return this.beforeBeginSession();
        }).then(() => {
            this.session.begin();
        }).catch((error) => {
            if (this.session) {
                this.session.abort();
            }
            this.onFailure(error);
        });
    },


    enableApplePayButtons: function () {
        let buttons = document.getElementsByClassName('apple-pay-button');

        for (let i = 0; i < buttons.length; i++) {
            let button = buttons[i];

            button.className += ' visible';
            button.addEventListener('click', this.beginApplePayPayment.bind(this));
        }
    },

    canMakePayments: function (checkActiveCard) {
        if (checkActiveCard === true) {
            return ApplePaySession.canMakePaymentsWithActiveCard(this.merchant_id);
        }

        return Promise.resolve(ApplePaySession.canMakePayments());
    },

    enable: function (checkActiveCard) {
        if (window.ApplePaySession) {
            this.canMakePayments(checkActiveCard).then((canMakePayments) => {
                if (canMakePayments) this.enableApplePayButtons();
            })
        }
    },


    basketToPaymentRequest: function (basket, paymentRequest) {
        let total = 0;

        paymentRequest.lineItems = basket.Lines.map((item) => {
            const amount = (parseInt(item.Price) / 100) * (parseInt(item.Qty) / 1000);
            total += amount;

            return { amount: amount.toFixed(2), label: item.Description }
        });

        if (typeof paymentRequest.total === 'undefined') {
            paymentRequest.total = {};
        }

        if (typeof paymentRequest.total.amount === 'undefined') {
            paymentRequest.total.amount = total.toFixed(2);
        }
    },
}
