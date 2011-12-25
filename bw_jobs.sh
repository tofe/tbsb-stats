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


#CheckOrCreateCustomerECV Stats

grep "ResolvePanECV, BWP.Core/Services/CheckOrCreateCustomerECV/Implementation/PerformCheckOrCreateCustomerECV.process, BWP.Core/Services/CheckOrCreateCustomerECV/Interface/wsPerformCheckOrCreateCustomerECV.process/Check or Create Customer ECV"  $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_CheckOrCreateCustomerECV_ResolvePAN.csv"

grep "CI Customer Compare, ProcessDefinitions/CustomerIndex/CustomerCompare/Implementation/CustomerCompare.process, BWP.Core/Services/CheckOrCreateCustomerECV/Interface/wsPerformCheckOrCreateCustomerECV.process/Check or Create Customer ECV>BWP.Core/Services/CheckOrCreateCustomerECV/Implementation/PerformCheckOrCreateCustomerECV.process/Compare Request with TSYS Customer" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_CheckOrCreateCustomerECV_CICustomerCompare.csv"

grep "Compare Request with TSYS Customer, BWP.Core/Services/CheckOrCreateCustomerECV/Implementation/PerformCheckOrCreateCustomerECV.process, BWP.Core/Services/CheckOrCreateCustomerECV/Interface/wsPerformCheckOrCreateCustomerECV.process/Check or Create Customer ECV"  $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_CheckOrCreateCustomerECV_TS2CustomerCompare.csv"

grep "Check if Customer exists in CI, BWP.Core/Services/CheckOrCreateCustomerECV/Implementation/PerformCheckOrCreateCustomerECV.process, BWP.Core/Services/CheckOrCreateCustomerECV/Interface/wsPerformCheckOrCreateCustomerECV.process/Check or Create Customer ECV" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_CheckOrCreateCustomerECV_CISearchCustomer.csv"

grep "Check or Create Customer ECV, BWP.Core/Services/CheckOrCreateCustomerECV/Interface/wsPerformCheckOrCreateCustomerECV.process" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_CheckOrCreateCustomerECV_TBSBTotal.csv"



#Set Mobile Number

grep "Retrieve Mobile Number from Credit Cards, BWP.Core/Services/SetMobileNumber/Implementation/PerformSetMobileNumber.process, BWP.Core/Services/SetMobileNumber/Interface/wsPerformSetMobileNumber.process/Perform Set Mobile Number"  $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_SetMobile_GetNumberTS2.csv"

grep "Perform Set Mobile Number, BWP.Core/Services/SetMobileNumber/Interface/wsPerformSetMobileNumber.process"  $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_SetMobile_TBSBTotal.csv"

grep "CI Search By Party Identifier, ProcessDefinitions/CustomerIndex/SearchByPartyIdentifer/Implementation/SearchByPartyIdentifier.process, BWP.Core/Services/SetMobileNumber/Interface/wsPerformSetMobileNumber.process/Perform Set Mobile Number>BWP.Core/Services/SetMobileNumber/Implementation/PerformSetMobileNumber.process/Search By Party Identifier" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_SetMobile_CISearchPartyByIdentifier.csv"


#Get Mobile Number

grep "CI Search By Party Identifier, ProcessDefinitions/CustomerIndex/SearchByPartyIdentifer/Implementation/SearchByPartyIdentifier.process, BWP.Core/Services/GetMobileNumber/Interface/wsPerformGetMobileNumber.process/Perform Get Mobile Number>BWP.Core/Services/GetMobileNumber/Implementation/PerformGetMobileNumber.process/Search By Party Identifier" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_GetMobile_CISearchPartyByIdentifier.csv"

grep "TS2 Inquire Cust info, ProcessDefinitions/CreditCards/GetCustomerInfo/Implementation/GetCustInfo.process, BWP.Core/Services/GetMobileNumber/Interface/wsPerformGetMobileNumber.process/Perform Get Mobile Number>BWP.Core/Services/GetMobileNumber/Implementation/PerformGetMobileNumber.process/Get Mobile from Credit Cards" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_GetMobile_TS2Inquire.csv"

grep "Perform Get Mobile Number, BWP.Core/Services/GetMobileNumber/Interface/wsPerformGetMobileNumber.process" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_GetMobile_TBSBTotal.csv"

#GetSCV

grep "CI Search By Party Identifier, ProcessDefinitions/CustomerIndex/SearchByPartyIdentifer/Implementation/SearchByPartyIdentifier.process, BWP.Core/Services/GetSCV/Interface/wsPerformGetSCV.process/Perform GetSCV HTTP>BWP.Core/Services/GetSCV/Implementation/PerformGetSCV.process/Retrieve Account Data from CI" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_GetSCV_CISearchPartyByIdentifier.csv"

grep "TS2 Inquire Multi, ProcessDefinitions/CreditCards/GetAccountDetails/Implementation/GetAccountDetails.process, BWP.Core/Services/GetSCV/Interface/wsPerformGetSCV.process/Perform GetSCV HTTP>BWP.Core/Services/GetSCV/Implementation/PerformGetSCV.process/Retrieve Account Data from Credit Cards" $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_GetSCV_TS2MultiInquiry.csv"

grep " Perform GetSCV HTTP, BWP.Core/Services/GetSCV/Interface/wsPerformGetSCV.process," $INPUTLOG >> $OUTPUTDIR/$SUBDIR/$HOSTNAME"_GetSCV_TBSBTotal.csv"


