# CCS Samples
Sample implementations of the Commom Component Specification

## Spec status

* Startup Manager: In community review
* Service Manager: Draft, interfaces used in code are based on a best guess
* Session Manager: Draft, interfaces used in code are based on a best guess
* Business Entity: In community review

## Dependencies

These samples are dependent on the CCSSSS (Startup-, Service- and Session-Manager spec) and the CCSBE Business Entity spec.. The interfaces can be downloaded here:

* [Startup-, Service- and Session-Manager](CCSSSS01.zip)
* [Business Enttiy](CCSBE01.zip)
 

## Sample procedures

* [boot.p](Consultingwerk/CcsSamples/boot.p) Framework bootstrap procedure, typically AppServer startup
* [invoke-custom-service.p](Consultingwerk/CcsSamples/CustomService/invoke-custom-service.p) Sample invoking custom service
* [get-customer-by-abstract-query.p](Consultingwerk/CcsSamples/BusinessEntity/Customer/get-customer-by-abstract-query.p) Sample reading data using abstract query
* [get-customer-by-querystring.p](Consultingwerk/CcsSamples/BusinessEntity/Customer/get-customer-by-querystring.p) Sample reading data using ABL query string
* [get-matches-by-named-query.p](Consultingwerk/CcsSamples/BusinessEntity/Euro2016/get-matches-by-named-query.p) Sample reading data using named query
* [update-customer.p] (Consultingwerk/CcsSamples/BusinessEntity/Customer/update-customer.p) Sample updating Customer records using the Business Entity

## Custom services sample

The custom service [IEuro2016ResultService](Consultingwerk/CcsSamples/CustomService/IEuro2016ResultService.cls) is implemented in two variants:

* [Euro2016ResultService](Consultingwerk/CcsSamples/CustomService/Euro2016ResultService.cls) using a Business Entity for data retrieval
* [OnlineEuro2016ResultService](Consultingwerk/CcsSamples/CustomService/OnlineEuro2016ResultService.cls) using a public REST service for data retrieval

Based on the session startup parameter (-param) one of the two services is used:

* -param managers=Consultingwerk\CcsSamples\managers.xml,services=Consultingwerk\CcsSamples\services.xml
* -param managers=Consultingwerk\CcsSamples\managers.xml,services=Consultingwerk\CcsSamples\services-online.xml

The service instance is maintained by the Service Manager.

![4GL](keep-calm.png)