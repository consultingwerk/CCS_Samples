/*------------------------------------------------------------------------
    File        : ttManagers.i
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     : Tue Jun 21 13:41:21 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE ttManagers NO-UNDO
    FIELD InitializationSequence AS INTEGER INIT ?
    FIELD ManagerType            AS CHARACTER
    FIELD ManagerImplementation  AS CHARACTER
    INDEX InitializationSequence IS PRIMARY UNIQUE InitializationSequence .
