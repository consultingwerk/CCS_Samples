/**********************************************************************
 * Copyright (C) 2006-2012 by Consultingwerk Ltd. ("CW") -            *
 * www.consultingwerk.de and other contributors as listed             *
 * below.  All Rights Reserved.                                       *
 *                                                                    *
 *  Software is distributed on an "AS IS", WITHOUT WARRANTY OF ANY    *
 *   KIND, either express or implied.                                 *
 *                                                                    *
 *  Contributors:                                                     *
 *                                                                    *
 **********************************************************************/
/*------------------------------------------------------------------------
    File        : get-customer-by-querystring.p
    Purpose     : fetches customer records by query string

    Syntax      :

    Description :

    Author(s)   :
    Created     : Wed Jun 22 02:45:08 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Ccs.BusinessLogic.*                                 FROM PROPATH.
USING Ccs.Common.*                                        FROM PROPATH.
USING Consultingwerk.CcsSamples.BusinessEntity.*          FROM PROPATH.
USING Consultingwerk.CcsSamples.Framework.BusinessLogic.* FROM PROPATH.

DEFINE VARIABLE oCustomerEntity AS IUpdatableBusinessEntity NO-UNDO .
DEFINE VARIABLE i               AS INTEGER                  NO-UNDO .
DEFINE VARIABLE hChanges        AS HANDLE                   NO-UNDO .

{Consultingwerk/CcsSamples/BusinessEntity/Customer/dsCustomer.i}

/* ***************************  Main Block  *************************** */

RUN Consultingwerk/CcsSamples/boot.p .

oCustomerEntity = CAST (Application:ServiceManager:getService(GET-CLASS (IBusinessEntity),
                                                              BusinessEntities:Customer:ToString()),
                        IUpdatableBusinessEntity) .


oCustomerEntity:getData (NEW GetDataRequest("eCustomer", "CustNum = 1"),
                         OUTPUT DATASET dsCustomer) .

TEMP-TABLE eCustomer:TRACKING-CHANGES = TRUE .

FIND FIRST eCustomer .

UPDATE eCustomer.CustNum
       eCustomer.Name
       eCustomer.SalesRep WITH 1 COL 1 DOWN .

RELEASE eCustomer .

CREATE DATASET hChanges.
hChanges:CREATE-LIKE (DATASET dsCustomer:HANDLE) .
hChanges:GET-CHANGES (DATASET dsCustomer:HANDLE) .

oCustomerEntity:updateData(INPUT-OUTPUT DATASET-HANDLE hChanges BY-REFERENCE, ?) .

hChanges:GET-BUFFER-HANDLE (1):FIND-FIRST () .

MESSAGE "error:" hChanges:GET-BUFFER-HANDLE (1):ERROR SKIP
        "error string:" SKIP hChanges:GET-BUFFER-HANDLE (1):ERROR-STRING SKIP
    VIEW-AS ALERT-BOX.


// Error handling
CATCH apperr AS Progress.Lang.AppError :
    MESSAGE apperr:GetMessage(1) SKIP
            apperr:ReturnValue         SKIP (2)
            apperr:CallStack
        VIEW-AS ALERT-BOX.
END CATCH.

CATCH err AS Progress.Lang.Error :
    MESSAGE err:GetMessage(1)       SKIP (2)
            err:CallStack

        VIEW-AS ALERT-BOX.
END CATCH.
