#!../../bin/linux-x86_64/cryomech

## You may have to change cryomech to something else
## everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/cryomech.dbd"
cryomech_registerRecordDeviceDriver pdbbase


# Define protocol path
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(CRYOMECH)/protocol")

epicsEnvSet("IP_ADDR1","10.112.63.215:4001")
epicsEnvSet("IP_ADDR2","10.112.63.215:4002")
epicsEnvSet("IP_ADDR3","10.112.63.215:4003")
epicsEnvSet("IP_ADDR4","10.112.63.215:4004")



asynSetAutoConnectTimeout(1.0)
drvAsynIPPortConfigure ("COM1","$(IP_ADDR1)",0,0,0)
drvAsynIPPortConfigure ("COM2","$(IP_ADDR2)",0,0,0)
drvAsynIPPortConfigure ("COM3","$(IP_ADDR3)",0,0,0)
drvAsynIPPortConfigure ("COM4","$(IP_ADDR4)",0,0,0)


#This prints low level commands and responses


dbLoadRecords("db/cryomech.db")


###############autosave##################
epicsEnvSet IOCNAME CRYOMECH
epicsEnvSet SAVE_DIR /home/controls/var/$(IOCNAME)

save_restoreSet_Debug(0)

### status-PV prefix, so save_restore can find its status PV's.
save_restoreSet_status_prefix("BL4A:CS:HPLC:")

set_requestfile_path("$(SAVE_DIR)")
set_savefile_path("$(SAVE_DIR)")

save_restoreSet_NumSeqFiles(3)
save_restoreSet_SeqPeriodInSeconds(600)
set_pass0_restoreFile("$(IOCNAME).sav")
set_pass0_restoreFile("$(IOCNAME)_pass0.sav")
set_pass1_restoreFile("$(IOCNAME).sav")
#########################################

cd "${TOP}/iocBoot/${IOC}"
iocInit

epicsThreadSleep(5)



#asynSetTraceMask("COM1",0,0x07)
#asynSetTraceIOMask("COM1",0,0x07)

###########################################
# Create request file and start periodic 'save'
epicsThreadSleep(5)
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME).req", "autosaveFields")
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME)_pass0.req", "autosaveFields_pass0")
create_monitor_set("$(IOCNAME).req", 5)
create_monitor_set("$(IOCNAME)_pass0.req", 30)


