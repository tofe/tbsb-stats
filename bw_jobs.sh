INPUTLOG=$1
HOSTNAME=$2
OUTPUTDIR=$3
SUBDIR=output

if [ -z "$1" ]
then
  echo "No input file"; echo "usage <script.sh> file_name host_name OUTPUT_DIR"
  exit
fi

if [ -z "$2" ]
then
  echo "No Host Name"; echo "usage <script.sh> file_name host_name OUTPUT_DIR"
  exit
fi

if [ -z "$3" ]
then
  echo "No Output Dir"; echo "usage <script.sh> file_name host_name OUTPUT_DIR"
  exit
fi

mkdir -p $OUTPUTDIR/$SUBDIR

#Send Temporary Pin Stats
grep "CI Search By Party Identifier, ProcessDefinitions/CustomerIndex/SearchByPartyIdentifer/Implementation/SearchByPartyIdentifier.process, BWP.Core/Services/SendTemporaryPIN/Interface/wsPerformSendTemoraryPin.process/Perform Send Temporary PIN>BWP.Core/Services/SendTemporaryPIN/Implementation/PerformSendTemporaryPIN.process/Search By Party Identifier" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_SendTempPin_CI.csv"

grep "TS2 Inquire Multi Info, ProcessDefinitions/CreditCards/GetCustomerAddress/Implementation/GetCustaddress.process, BWP.Core/Services/SendTemporaryPIN/Interface/wsPerformSendTemoraryPin.process/Perform Send Temporary PIN>BWP.Core/Services/SendTemporaryPIN/Implementation/PerformSendTemporaryPIN.process/Retrieve Customer Address from Credit Cards" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_SendTempPin_TS2.csv"

grep "CSSO Set Temporary Pin, ProcessDefinitions/CSSO/SetTemporaryPin/Implementation/SetTemporaryPin.process, BWP.Core/Services/SendTemporaryPIN/Interface/wsPerformSendTemoraryPin.process/Perform Send Temporary PIN>BWP.Core/Services/SendTemporaryPIN/Implementation/PerformSendTemporaryPIN.process/Set Temporary Pin in CSSO" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_SendTempPin_CSSO.csv"

grep "Perform Send Temporary PIN, BWP.Core/Services/SendTemporaryPIN/Interface/wsPerformSendTemoraryPin.process" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_SendTempPin_TBSBTotal.csv"

