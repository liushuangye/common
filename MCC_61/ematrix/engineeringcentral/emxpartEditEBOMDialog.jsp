<%--  emxpartEditEBOMDialog.jsp   - Dialog page to edit EBOM relationship.
   Copyright (c) 2001-2007 Dassault Systemes. All Rights Reserved.
   This program contains proprietary and trade secret information of MatrixOne,Inc.
   Copyright notice is precautionary only and does not evidence any actual or intended publication of such program

   static const char RCSID[] = $Id: emxpartEditEBOMDialog.jsp.rca 1.26.1.5 Fri Sep 28 15:19:56 2007 jtran Experimental przemek $
--%>

<%@include file = "emxDesignTopInclude.inc"%>
<%@include file = "emxEngrVisiblePageInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@include file = "../emxJSValidation.inc" %>
<%@include file = "../common/emxUIConstantsInclude.inc"%>
<%@include file = "emxengchgValidationUtil.js"%>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script>

<script language="Javascript">

<%
  String languageStr = request.getHeader("Accept-Language");
  String partName    = emxGetParameter(request,"objectName");
  String partRev     = emxGetParameter(request,"objectRev");
  String relId       = emxGetParameter(request,"relId");
  String objectId    = emxGetParameter(request,"objectId");
  String parentOID   = emxGetParameter(request,"parentOID");
  String attrFindNumber          = PropertyUtil.getSchemaProperty(context, "attribute_FindNumber");
  String attrRef                 = PropertyUtil.getSchemaProperty(context, "attribute_ReferenceDesignator");
  String attrQuantity            = PropertyUtil.getSchemaProperty(context, "attribute_Quantity");
  String attrUsage               = PropertyUtil.getSchemaProperty(context, "attribute_Usage");

  //add by liufeng 2019.10.17
  //get part weight attribute name
  String attrWeight= PropertyUtil.getSchemaProperty(context, "attribute_Weight");

  String rdValue="";
  String strRd="";
  // Get the alias name for this Part type.  If there is an icon defined in the
  // EC properties file for this alias, then use it.  Otherwise, use the
  // default icon
  BusinessObject partObj = new BusinessObject(objectId);
  partObj.open(context);
  String partType = partObj.getTypeName();
  String alias = FrameworkUtil.getAliasForAdmin(context, "type", partType, true);
  partObj.close(context);

  StringBuffer partTNR = new StringBuffer();
  partTNR.append(partType);
  partTNR.append(" ");
  partTNR.append(partName);
  partTNR.append(" ");
  partTNR.append(partRev);
  DomainRelationship domRel = new DomainRelationship(relId);
  domRel.open(context);
  parentOID = (String)(domRel.getFrom()).getObjectId(context);
  domRel.close(context);

  Part domObj = (Part)DomainObject.newInstance(context,
                    DomainConstants.TYPE_PART,DomainConstants.ENGINEERING);
  domObj.setId(parentOID);

  String fnRequired   = JSPUtil.getCentralProperty(application, session,alias,"FindNumberRequired");
  if(fnRequired==null || "null".equals(fnRequired) || "".equals(fnRequired))
  {
      fnRequired= EngineeringUtil.getParentTypeProperty(context,partObj.getTypeName(),"FindNumberRequired");
  }
  String rdRequired   = JSPUtil.getCentralProperty(application, session,alias,"ReferenceDesignatorRequired");
  if(rdRequired==null || "null".equals(rdRequired) || "".equals(rdRequired))
  {
      rdRequired= EngineeringUtil.getParentTypeProperty(context,partObj.getTypeName(),"ReferenceDesignatorRequired");
  }

        StringList selectStmts = new StringList(1);
        selectStmts.addElement(DomainObject.SELECT_ID);
        StringList selectRelStmts = new StringList(3);
        selectRelStmts.addElement(DomainObject.SELECT_ATTRIBUTE_FIND_NUMBER);
        selectRelStmts.addElement(DomainObject.SELECT_ATTRIBUTE_REFERENCE_DESIGNATOR);
        selectRelStmts.addElement(DomainObject.SELECT_RELATIONSHIP_ID);

        // get Relationship Data like Find Number and use in checking for uniqueness
        MapList ebomList = domObj.getRelatedObjects(context,
                                             DomainObject.RELATIONSHIP_EBOM,    // relationship pattern
                                             DomainObject.TYPE_PART,            // object pattern
                                             selectStmts,                 // object selects
                                             selectRelStmts,              // relationship selects
                                             false,                       // to direction
                                             true,                        // from direction
                                             (short)1,                    // recursion level
                                             null,   // object where clause
                                             "id[connection]!="+relId);
        int i = 0;
        int k = 0;
        String fnValue = "";
        String fnId = "";
        Iterator bomItr = ebomList.iterator();
        while(bomItr.hasNext())
        {

            k++;
            Map bomMap = (Map)bomItr.next();
            fnValue = (String)bomMap.get(DomainObject.SELECT_ATTRIBUTE_FIND_NUMBER);
            rdValue = (String)bomMap.get(DomainObject.SELECT_ATTRIBUTE_REFERENCE_DESIGNATOR);
            fnId    = (String)bomMap.get(DomainObject.SELECT_ID);
            if(k ==1)
            {
              strRd=rdValue;
            }
            else
            {
               strRd=strRd + "," + rdValue;

            }
%>
                rdArray["<%=i%>"]="<%=rdValue%>";
                fnArray["<%=i%>"]="<%=fnValue%>";


<%
                i++;
        }


   ////Find Number Feature - coding
  String typeIcon;
  String defaultTypeIcon = JSPUtil.getCentralProperty(application, session, "type_Default","SmallIcon");

  if ( (alias == null) || (alias.equals("null")) || (alias.equals("")) )
  {
    typeIcon = defaultTypeIcon;
  }
  else
  {
    typeIcon = JSPUtil.getCentralProperty(application, session, alias, "SmallIcon");
  }
%>
TNRArray[0]="<%=partTNR.toString()%>";
</script>
  <script language="JavaScript">
 ///overridden method to validate the find number agains the dbvalues
 //method overridden as only one part is present on the form
   function getNonUniqueFN(inputFN)
   {
       var nonUniqueFNs = "";
 //checking for uniqueness against db values. fnArray contains the db Find Number Values
        for(var i=0;i<fnArray.length;i++)
        {
            if(fnArray[i]==inputFN)
            {
               nonUniqueFNs=TNRArray[0];
            }
        }
        return nonUniqueFNs;
   }

    function validateForm()
    {
      var qty = document.editForm.elements["<%=attrQuantity%>"];
      var findNumber = document.editForm.elements["<%=attrFindNumber%>"];
      //add by liufeng 2019.10.17
      //get the filled part weight value in the editForm
      var weight = document.editForm.elements["<%=attrWeight%>"];

      selectObject = document.editForm.elements["<%=attrUsage%>"];
      var RefDesignator = document.editForm.elements["<%=DomainObject.ATTRIBUTE_REFERENCE_DESIGNATOR%>"];
      var ParentStr      = "<%=strRd%>";
      var RefArray = new Array();
      RefArray = rdArray;
      var fnRequired = "<%=fnRequired%>";
      var rdRequired = "<%=rdRequired%>";
      var usage = null;
      if(selectObject != null) {
        selectObject.options[selectObject.selectedIndex];
      }
      var rdvalue = RefDesignator.value;
      if (findNumber != null || RefDesignator != null)
      {
        var findNumberValue = trim(findNumber.value);
        if(!validateFNRD(findNumber,RefDesignator,fnRequired,rdRequired,0,1))
         {
             return;
         }

          var nonUniqueFNs ="";
          if (findNumberValue.length!=0)
          {
              nonUniqueFNs=getNonUniqueFN(findNumberValue);
          }
          if(fnUniqueness=="true" && nonUniqueFNs.length>0)
          {
             alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.BuildEBOM.FNNotUniqueForTNR</emxUtil:i18nScript>"+nonUniqueFNs);
             findNumber.focus();
             return;
          }
          else if(fnUniqueness!="true" && rdUniqueness!="true")
          {
              if(nonUniqueFNs.length>0)
              {
                 alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.BuildEBOM.FNNotUniqueForTNR</emxUtil:i18nScript>"+nonUniqueFNs);
                 findNumber.focus();
                 return;
              }

          }
          if(rdUniqueness=="true")
          {
            var refstr=RefArray.join()
            unique = isRDUnique(refstr,rdvalue)
            if(!unique)
            {
                alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.ReferenceDesignator.NotUnique</emxUtil:i18nScript>");
                RefDesignator.focus();
                return;
            }
         }
   }


      if (qty != null)
      {

        var qtyvalue = trim(qty.value);

        if( isEmpty(qtyvalue)) {
          alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.BuildEBOM.Quantityfieldisemptypleaseenteranumber</emxUtil:i18nScript>");
          qty.focus();
          return;
        }
        if(!isNumeric(qtyvalue)) {
          alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.Common.QuantityHasToBeANumber</emxUtil:i18nScript>");
          qty.focus();
          return;
        }
        if(qtyvalue.substr(0,1) == '-') {
          alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.Common.QuantityHasToBeAPositiveNumber</emxUtil:i18nScript>");
          qty.focus();
          return;
        }
         /*commented for the bug no 332272
         //added for the 305791
         if(qtyvalue.indexOf(".") != -1){
                alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.Common.QuantityHasToBeNumber</emxUtil:i18nScript>");
                qtyobj.focus();
                return;
              }
           // end the bug 305791
        */
        if(!isEmpty(rdvalue))
        {

            var qt = getRDQuantity(rdvalue)
            if (parseInt(qtyvalue) != parseInt(qt))
            {
                alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.ReferenceDesignator.SingleQuantity</emxUtil:i18nScript>");
                qty.focus();
                return;
            }
            if(qt==0)
            {
                alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.ReferenceDesignator.SingleQuantity</emxUtil:i18nScript>");
                qty.focus();
                return;
            }
        }

      }
      //add by liufeng 2019.10.17
      //Part weight value validate
      if (weight != null)
      {

        var weightvalue = trim(weight.value);

        if( isEmpty(weightvalue)) {
          alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.BuildEBOM.Weightfieldisemptypleaseenteranumber</emxUtil:i18nScript>");
          weight.focus();
          return;
        }
        if(!isNumeric(weightvalue)) {
          alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.Common.WeightHasToBeANumber</emxUtil:i18nScript>");
          weight.focus();
          return;
        }
        if(weightvalue.substr(0,1) == '-') {
          alert("<emxUtil:i18nScript localize="i18nId">emxEngineeringCentral.Common.WeightHasToBeAPositiveNumber</emxUtil:i18nScript>");
          weight.focus();
          return;
        }
      }
      return true;
  }

    function doneMethod()
    {
        if (validateForm())
        {
            document.editForm.submit();
        }
    }

    function cancelMethod()
    {
        top.close();
    }
</script>

<%@include file = "../emxUICommonHeaderEndInclude.inc" %>

<form name="editForm" method="post" action="emxpartEditEBOMProcess.jsp"  onSubmit="javascript:doneMethod(); return false">
<table border="0" cellpadding="5" cellspacing="2" width="100%">
  <tr>
    <td width="25%" class="label"><emxUtil:i18n localize="i18nId">emxEngineeringCentral.Common.Part</emxUtil:i18n></td>
    <td class="label"><img src="../common/images/<%=typeIcon%>" border="0">&nbsp;<%=partName%></td>
  </tr>

<%

  DomainRelationship ebomRel = DomainRelationship.newInstance(context,relId);
  ebomRel.open(context);
  Map attrTypeMap = ebomRel.getAttributeDetails(context);
  ebomRel.close(context);
  //add by liufeng 2019.10.17
  //Get this part attribute details
  DomainObject objRel = DomainObject.newInstance(context,objectId);
  objRel.open(context);
  Map objAttrTypeMap = objRel.getAttributeDetails(context);
  objRel.close(context);
 Map objinfo = (Map) objAttrTypeMap.get(attrWeight);
  Iterator itr = attrTypeMap.keySet().iterator();
  String key = "";
  while(itr.hasNext()) {
    key = (String)itr.next();
    Map info = (Map) attrTypeMap.get(key);
    
    //add by liufeng 2019.10.17
    //add weight judgment
    if(key.equals(attrFindNumber) && "true".equalsIgnoreCase(fnRequired) || key.equals(attrQuantity) || key.equals(attrUsage)|| key.equals(attrWeight) || key.equals(attrRef) && "true".equalsIgnoreCase(rdRequired)) {
%>
    <tr>
      <td width="25%" class="labelRequired"><%=getAttributeI18NString( key, languageStr)%></td>
<%
    } else {
%>
    <tr>
      <td width="25%" class="label"><%=getAttributeI18NString( key, languageStr)%></td>
<%
    }
%>
  <td class="inputField"><%=displayField(context,info,"edit",languageStr,session,"")%>&nbsp;</td>
   </tr>   
<%
}
//add by liufeng 2019.10.17
// get part weight value and display it in the foreground
%>
<tr>
  <td width="25%" class="labelRequired"><%=getAttributeI18NString( attrWeight, languageStr)%></td>
  <td class="inputField"><%=displayField(context,objinfo,"edit",languageStr,session,"")%>&nbsp;</td>
</tr>


</table>
<input type="hidden" name="relId" value="<%=relId%>">
<input type="hidden" name="objectId" value="<%=objectId%>">
<input type="image" name="inputImage" height="1" width="1" src="../common/images/utilSpacer.gif" hidefocus="hidefocus"
style="-moz-user-focus: none" />

</form>
<%@include file = "emxDesignBottomInclude.inc"%>
<%@include file = "../emxUICommonEndOfPageInclude.inc" %>
