/*------------------------------------------------------------------------
    File        : get-matches-by-named-query.p
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     : Wed Jun 22 11:26:33 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Consultingwerk.CcsSamples.CustomService.* FROM PROPATH.
USING Ccs.BusinessLogic.*                                 FROM PROPATH .
USING Ccs.Common.*                                        FROM PROPATH .
USING Consultingwerk.*                                    FROM PROPATH .
USING Consultingwerk.CcsSamples.Framework.BusinessLogic.* FROM PROPATH .

DEFINE VARIABLE oMatches AS IBusinessEntity         NO-UNDO .
DEFINE VARIABLE oCount   AS IGetResultCountResponse NO-UNDO .

{Consultingwerk/CcsSamples/BusinessEntity/Euro2016/dsMatches.i}

/* ***************************  Main Block  *************************** */

RUN Consultingwerk/CcsSamples/boot.p .

oMatches = CAST (Application:ServiceManager:getService(GET-CLASS (IBusinessEntity), "Matches"), IBusinessEntity) .

oCount = oMatches:getResultCount (NEW GetDataRequest (NEW NamedQuery("today":U))) .

MESSAGE STRING (oMatches) SKIP
        "There are" oCount:ResultCounts[1]:NumResults "matches today."
    VIEW-AS ALERT-BOX.

// And now the matches of the world champion
//                                                   qryname paramname paramvalue
oMatches:getData(NEW GetDataRequest (NEW NamedQuery ("team", "team", NEW CharacterHolder ("Germany"))),
                 OUTPUT DATASET dsMatches BY-REFERENCE) .

FOR EACH eMatches:
    MESSAGE NEW MatchResult (BUFFER eMatches:HANDLE)
        VIEW-AS ALERT-BOX.
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
