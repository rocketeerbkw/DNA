<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestComments.aspx.cs" Inherits="TestComments" %>
<%
	if (Request["template"] == null)
	{
		%>
		<html>
			<head>
				<title>Comments Test Pages</title>
			</head>
			<body>
				<form method="get" action="testComments.aspx">
					<select name="template">
						<% OutputOptionTemplates(); %>
					</select>
					<br />
						<input type="radio" name="newid" value="generate" /> Generate Random UID<br />
						<input type="radio" name="newid" value="custom" /> Use Custom UID: <input type="text" name="customuid" /><br />
						Site: <select name="sitename">
							<% OutputSitenameOptions(); %>
						</select>
						<br />
						Title: <input type="text" name="title" /><br />
						Host: <select name="host">
						<option value="<%= Page.Request.ServerVariables["HTTP_HOST"] %>"><%= Page.Request.ServerVariables["HTTP_HOST"] %></option>
						<option value="local.bbc.co.uk">local.bbc.co.uk</option>
						<option value="dnadev.national.core.bbc.co.uk">dnadev.national.core.bbc.co.uk</option>
						<option value="dnarelease.national.core.bbc.co.uk">dnarelease.national.core.bbc.co.uk</option>
						<option value="dna-staging.bbc.co.uk">dna-staging.bbc.co.uk</option>
						<option value="dna-extdev.bbc.co.uk">dna-extdev.bbc.co.uk</option>
						<option value="www.bbc.co.uk">www.bbc.co.uk</option>
						</select>
						<br />
						<input type="checkbox" name="staging" value="1" />Staging<br />
						<input type="submit" name="submit" value="Create Page" />
				</form>
			</body>
		</html>
		<%
	}
	else
	{
		RenderPage();
	}
%>