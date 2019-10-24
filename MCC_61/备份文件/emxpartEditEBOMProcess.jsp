<%-- emxpartEditEBOMProcess.jsp - Process page to edit EBOM relationship.

   Copyright (c) 1992-2007 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of MatrixOne,
   Inc.  Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

   static const char RCSID[] = $Id: emxpartEditEBOMProcess.jsp.rca 1.12.1.2 Mon Aug  6 19:59:20 2007 przemek Experimental przemek $
--%>

<%@include file = "emxDesignTopInclude.inc"%>
<%@include file = "emxEngrVisiblePageInclude.inc"%>

<%
  String objectId = emxGetParameter(request, "objectId");
  String relId    = emxGetParameter(request, "relId");

  DomainRelationship ebomRel = DomainRelationship.newInstance(context,relId);

  String attrFindNumber          = PropertyUtil.getSchemaProperty(context, "attribute_FindNumber");
  String attrQuantity            = PropertyUtil.getSchemaProperty(context, "attribute_Quantity");
  String attrReferenceDesignator = PropertyUtil.getSchemaProperty(context, "attribute_ReferenceDesignator");
  String attrUsage               = PropertyUtil.getSchemaProperty(context, "attribute_Usage");
  String attrComponentLocation   = PropertyUtil.getSchemaProperty(context, "attribute_ComponentLocation");

  String relType = PropertyUtil.getSchemaProperty(context , "relationship_EBOM");
%>
  <%@include file = "emxEngrStartUpdateTransaction.inc"%>
<%


  String attrFindNumberValue = emxGetParameter(request, attrFindNumber);
  String attrReferenceDesignatorValue = emxGetParameter(request, attrReferenceDesignator);

  HashMap attrmap = new HashMap();

  Map map = ebomRel.getAttributeDetails(context,false);

  Iterator it = map.keySet().iterator();
  while(it.hasNext())
  {
      String key = (String)it.next();
      Map info = (Map) map.get(key);
      String attrName = (String) info.get("name");
      String attrValue = emxGetParameter(request, attrName);
      attrmap.put(attrName, attrValue);
  }

  try {
    ebomRel.setAttributeValues(context,attrmap);
  }
  catch(Exception Ex)
  {
%>
    <%@include file = "emxEngrAbortTransaction.inc"%>
<%
    session.putValue("error.message", Ex.toString());
  }
%>
    <%@include file = "emxEngrCommitTransaction.inc"%>
    <%@include file = "emxDesignBottomInclude.inc"%>

<script language="Javascript">
  parent.window.opener.parent.location.href = parent.window.opener.parent.location.href;
  parent.window.close();
</script>
