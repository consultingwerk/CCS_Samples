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
    File        : get-customer-by-abstract-query.p
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

DEFINE VARIABLE oRequest AS GetDataRequest NO-UNDO .

{Consultingwerk/CcsSamples/BusinessEntity/Customer/dsCustomer.i}

/* ***************************  Main Block  *************************** */

RUN Consultingwerk/CcsSamples/boot.p .

oCustomerEntity = CAST (Application:ServiceManager:getService(GET-CLASS (IBusinessEntity),
                                                              BusinessEntities:Customer:ToString()),
                        IBusinessEntity) .

/*// SalesRep = "BBB" AND Country = "USA"                                                                                                              */
/*oRequest = NEW GetDataRequest (NEW GetDataTableRequest("eCustomer",                                                                                  */
/*                                                       QueryEntry:Array(NEW QueryPredicate("SalesRep", QueryOperatorEnum:Eq, "BBB"),                 */
/*                                                                        NEW QueryPredicate(JoinEnum:And, "Country", QueryOperatorEnum:Eq, "USA")))) .*/

// SalesRep = "BBB" AND Country = "USA" AND NOT (City BEGINS "B" OR City BEGINS "C"
oRequest = NEW GetDataRequest (NEW GetDataTableRequest("eCustomer",
                                                       QueryEntry:Array(NEW QueryPredicate ("SalesRep", QueryOperatorEnum:Eq, "BBB"),
                                                                        NEW QueryPredicate (JoinEnum:And, "Country", QueryOperatorEnum:Eq, "USA"),
                                                                        NEW QueryGroup (JoinEnum:AndNot,
                                                                                        QueryEntry:Array(NEW QueryPredicate("City", QueryOperatorEnum:Begins, "B"),
                                                                                                         NEW QueryPredicate(JoinEnum:Or, "City", QueryOperatorEnum:Begins, "C")))))) .


oCustomerEntity:getData (oRequest,
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