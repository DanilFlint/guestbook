<%@ include file="../init.jsp" %>

<liferay-ui:success key="entryAdded" message="entry-added" />
<liferay-ui:success key="entryDeleted" message="entry-deleted" />

<%-- <div id="<portlet:namespace />-root"></div>

<aui:script require="<%= mainRequire %>">
	main.default('<portlet:namespace />-root');
</aui:script> --%>

<%
long guestbookId = Long.valueOf((Long) renderRequest
        .getAttribute("guestbookId"));
%>

<portlet:renderURL var="searchURL">
    <portlet:param name="mvcPath" 
    value="/guestbookwebportlet/view_search.jsp" />
</portlet:renderURL>

<aui:form action="${searchURL}" name="fm">

    <div class="row">
        <div class="col-md-8">
            <aui:input inlineLabel="left" label="" name="keywords" placeholder="search-entries" size="256" />
        </div>

        <div class="col-md-4">
            <aui:button type="submit" value="search" />
        </div>
    </div>
</aui:form>

<aui:nav cssClass="nav-tabs">

    <%
        List<Guestbook> guestbooks = GuestbookLocalServiceUtil.getGuestbooks(scopeGroupId);

            for (int i = 0; i < guestbooks.size(); i++) {

                Guestbook curGuestbook = guestbooks.get(i);
                String cssClass = StringPool.BLANK;

                if (curGuestbook.getGuestbookId() == guestbookId) {
                    cssClass = "active";
                }

                if (GuestbookModelPermission.contains(
                    permissionChecker, curGuestbook.getGuestbookId(), "VIEW")) {

    %>

    <portlet:renderURL var="viewPageURL">
        <portlet:param name="mvcPath" value="/guestbookwebportlet/view.jsp" />
        <portlet:param name="guestbookId"
            value="<%=String.valueOf(curGuestbook.getGuestbookId())%>" />
    </portlet:renderURL>


    <aui:nav-item cssClass="<%=cssClass%>" href="<%=viewPageURL%>"
        label="<%=HtmlUtil.escape(curGuestbook.getName())%>" />

    <%  
                }

            }
    %>

</aui:nav>

<aui:button-row cssClass="guestbook-buttons">

	<c:if test='<%= GuestbookPermission.contains(permissionChecker, scopeGroupId, "ADD_ENTRY") %>'>

	    <portlet:renderURL var="addEntryURL">
	        <portlet:param name="mvcPath" value="/guestbookwebportlet/edit_entry.jsp" />
	        <portlet:param name="guestbookId"
	            value="<%=String.valueOf(guestbookId)%>" />
	    </portlet:renderURL>
	    
    	<aui:button onClick="<%=addEntryURL.toString()%>" value="Add Entry"></aui:button>
    </c:if>


</aui:button-row>

<liferay-ui:search-container total="<%=EntryLocalServiceUtil.getEntriesCount()%>">
<liferay-ui:search-container-results
    results="<%=EntryLocalServiceUtil.getEntries(scopeGroupId.longValue(),
                    guestbookId, searchContainer.getStart(),
                    searchContainer.getEnd())%>" />

<liferay-ui:search-container-row
    className="com.liferay.docs.guestbook.model.Entry" modelVar="entry">

    <liferay-ui:search-container-column-text property="message" />

    <liferay-ui:search-container-column-text property="name" />
    
    <liferay-ui:search-container-column-jsp path="/guestbookwebportlet/entry_actions.jsp" align="right" />

</liferay-ui:search-container-row>

<liferay-ui:search-iterator />

</liferay-ui:search-container>