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
    File        : StartupManager
    Purpose     : Sample CCS IStartupManager implementation
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Jun 21 13:09:01 CEST 2016
    Notes       : Configured from managers.xml file in the application
                  working directory or an managers=<file name> entry in
                  the -param starutp parameter
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Progress.Reflect.* FROM PROPATH.
USING Ccs.Common.*                               FROM PROPATH .
USING Consultingwerk.CcsSamples.StartupManager.* FROM PROPATH .
USING Progress.Lang.*                            FROM PROPATH .

CLASS Consultingwerk.CcsSamples.StartupManager.StartupManager
    IMPLEMENTS IStartupManager:

    {Consultingwerk/CcsSamples/StartupManager/ttManagers.i}

    DEFINE TEMP-TABLE ttManagerInstances NO-UNDO
        FIELD ManagerType           AS Progress.Lang.Object
        FIELD ManagerImplementation AS Progress.Lang.Object
        INDEX ManagerType IS PRIMARY UNIQUE ManagerType .

    /**
     * Purpose: Default constructor for the Startup Manager
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC StartupManager():
        /* noop */
    END CONSTRUCTOR.

    /**
     * Purpose: Returns the reference to the specified IManager instance.
     * Notes:
     * @param poServiceType The Progress.Lang.Class repersenting the required service.
     * @return The IManager implementation of the requested type, or ? if none are configured.
     */
    METHOD PUBLIC Ccs.Common.IManager getManager (poServiceType AS Progress.Lang.Class):

        IF NOT VALID-OBJECT (poServiceType) THEN
            UNDO, THROW NEW AppError ("Invald manager type '?'", 0) .

        IF NOT CAN-FIND (ttManagerInstances WHERE ttManagerInstances.ManagerType = poServiceType) THEN
            UNDO, THROW NEW AppError (SUBSTITUTE ("&1 is not a configured manager", poServiceType:TypeName), 0) .

        FIND ttManagerInstances WHERE ttManagerInstances.ManagerType = poServiceType .

        RETURN CAST (ttManagerInstances.ManagerImplementation, IManager) .

    END METHOD.

    /**
     * Purpose: Initializes the Service
     * Notes:   Implements the actual framework bootstrap
     *
     */
    METHOD PUBLIC VOID initialize ():

        DEFINE VARIABLE cManagersFile AS CHARACTER NO-UNDO INIT "managers.xml":U.
        DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iCount        AS INTEGER   NO-UNDO.

        /* Do we have a managers= entry in -param */
        ASSIGN iCount = NUM-ENTRIES (SESSION:PARAM) .

        paramLoop:
        DO i = 1 TO iCount:
            IF ENTRY (i, SESSION:PARAM) BEGINS "managers=":U THEN DO:
                ASSIGN cManagersFile = ENTRY (2, ENTRY (i, SESSION:PARAMETER), "=":U) .
                LEAVE paramLoop .
            END.
        END.

        FILE-INFO:FILE-NAME = cManagersFile .

        IF FILE-INFO:FULL-PATHNAME = ? THEN
            UNDO, THROW NEW AppError (SUBSTITUTE ("Invalid managers definition: &1", cManagersFile), 0) .

        TEMP-TABLE ttManagers:READ-XML ("file":U, FILE-INFO:FULL-PATHNAME, ?, ?, ?) .

        THIS-OBJECT:InitializeManagers() .

    END METHOD.

    /**
     * Purpose: Initializes the managers from ttManagers
     * Notes:
     *
     */
    METHOD PROTECTED VOID InitializeManagers():

        DEFINE VARIABLE oType         AS Progress.Lang.Class  NO-UNDO .
        DEFINE VARIABLE oInstanceType AS Progress.Lang.Class  NO-UNDO .
        DEFINE VARIABLE oInstance     AS Progress.Lang.Object NO-UNDO .

        FOR EACH ttManagers WHERE ttManagers.InitializationSequence > 0:

            ASSIGN
                oType         = Progress.Lang.Class:GetClass (ttManagers.ManagerType)
                oInstanceType = Progress.Lang.Class:GetClass (ttManagers.ManagerImplementation)
                oInstance     = oInstanceType:GetConstructor (Flags:Public,
                                                              NEW ParameterList (0)):Invoke (NEW ParameterList (0)) .

            IF NOT TYPE-OF (oInstance, IManager) THEN
                UNDO, THROW NEW AppError (SUBSTITUTE ("&1 is not an IManager", oInstanceType:TypeName), 0) .

            CAST (oInstance, IManager):initialize() .

            CREATE ttManagerInstances.
            ASSIGN ttManagerInstances.ManagerType           = oType
                   ttManagerInstances.ManagerImplementation = oInstance .

            RELEASE ttManagerInstances .

            CASE oType:
                WHEN GET-CLASS (IServiceManager) THEN
                    Application:ServiceManager = CAST (oInstance, IServiceManager) .
                WHEN GET-CLASS (ISessionManager) THEN
                    Application:SessionManager = CAST (oInstance, ISessionManager) .
                WHEN GET-CLASS (IStartupManager) THEN
                    Application:StartupManager = CAST (oInstance, IStartupManager) .
            END CASE .

        END.

    END METHOD.

END CLASS.
