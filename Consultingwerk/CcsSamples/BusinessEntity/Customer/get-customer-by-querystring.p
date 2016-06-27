/**********************************************************************
 * Copyright (C) 2006-2016 by Consultingwerk Ltd. ("CW") -            *
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

DEFINE VARIABLE oCustomerEntity AS IBusinessEntity NO-UNDO .
DEFINE VARIABLE i               AS INTEGER         NO-UNDO .

{Consultingwerk/CcsSamples/BusinessEntity/Customer/dsCustomer.i}

/* ***************************  Main Block  *************************** */

RUN Consultingwerk/CcsSamples/boot.p .

oCustomerEntity = CAST (Application:ServiceManager:getService(GET-CLASS (IBusinessEntity),
                                                              BusinessEntities:Customer:ToString()),
                        IBusinessEntity) .


oCustomerEntity:getData (NEW GetDataRequest("eCustomer", "SalesRep = 'HXM' AND Name BEGINS 'Li'"),
                         OUTPUT DATASET dsCustomer) .

FOR EACH eCustomer:
    i = i + 1 .
END.

MESSAGE "results:" i
    VIEW-AS ALERT-BOX.

FOR EACH eCustomer:
    DISPLAY eCustomer.CustNum
            eCustomer.Name
            eCustomer.SalesRep WITH DOWN .
END.

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
