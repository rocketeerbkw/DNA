/* This source code is part of the Virtual Windows Class Library (VWCL). VWCL is a public C++ class library,
placed in the public domain, and is open source software. VWCL is not governed by any rules other than these:
1) VWCL may be used in commercial and other applications.
2) VWCL may not be distributed, in source code form, in development related projects, unless the developer is also a VWCL contributor.
3) VWCL may be used in development related projects in binary, compiled form, by anyone.
4) VWCL shall remain open source software regardless of distribution method.
5) A proper copyright notice referencing the "VWCL Alliance" must be included in the application and/or documentation.
6) No company or individual can ever claim ownership of VWCL.
7) VWCL source code may be modified or used as a base for another class library.
8) Your use of this software forces your agreement to not hold any member, individual or company, liable for any damages
resulting from the use of the provided source code. You understand the code is provided as-is, with no warranty expressed
or implied by any member of the VWCL Alliance. You use this code at your own risk.

Primary Author of this source code file:  Todd Osborne (todd@vwcl.org)
Other Author(s) of this source code file: 

VWCL and all source code are copyright (c) 1996-1999 by The VWCL Alliance*/

#ifndef VSMTPSOCKET
#define VSMTPSOCKET

#include "../vstandard.h"
#include "../strings/vstring.hpp"
#include <winsock.h>

/* VSMTPSocket is a SMTP (RFC 821 Compliant) EMail Sender. ALWAYS initialize WinSock with WSAStartup() before using
this class! This class is very old, and in need of updating. Much improved sockets support is planned for a future
release, and while this code generally will work, it remains in VWCL only as a reference implementation.
Normal usage generally goes like this:
1) Create an instance of a VSMTPSocket class.
2) Call Connect() to connect a socket to the SMTP server.
3) Call SendHello() to start communications with SMTP server.
4) Call SendMailFrom() to tell the SMTP server who is sending the mail.
5) Call SendRecipient() one or more times to tell the SMTP server who the mail is going to.
6) Call SendData() to tell the SMTP server you are ready to start sending data.
7) Call SendMessage() as many times as needed to send data.
8) Call SendEndData() to tell SMTP server you are done sending data.
9) Call SendQuit() to tell the SMTP server you are done talking to it.
10) Call Disconnect() to close the socket or destruct the object.
OR
1) Create an instance of a VSMTPSocket class.
2) Call Connect() to connect a socket to the SMTP server.
3) Call SendAll() to handle entire process.
4) Call Disconnect() to close the socket or destruct the object.*/
class VSMTPSocket
{
public:
	// Default constructor can be initialized with the host name (SMTP sever) to connect to, or NULL.
	VSMTPSocket(VSTRING_CONST pszHostName = NULL)
	{
		// Initialize.
		m_Socket = INVALID_SOCKET;
		ZeroMemory(m_szLastServerString, VARRAY_SIZE(m_szLastServerString));

		// Connect socket now if pszHostName is non-NULL.
		if ( pszHostName )
			Connect(pszHostName);
	}

	// Virtual destructor verifies disconnection from server, as needed.
	virtual ~VSMTPSocket()
		{ Disconnect(); }

	// Class constants.
	enum	{	DEFAULT_PROTOCOL =				0,
				DOMAIN_MAX_BUFFER_SIZE =		64,
				USER_NAME_MAX_BUFFER_SIZE =		64,
				SMTP_MAX_BUFFER_SIZE =			1000,
				SMTP_MAX_COMMAND_BUFFER_SIZE =	512,
				SMTP_MAX_REPLY_BUFFER_SIZE =	512,
			};

	// Error value returns from Connect().
	enum	{	ERROR_CONNECT_NONE,
				ERROR_CONNECT_BAD_HOST_NAME,
				ERROR_CONNECT_FAILED_ALLOC_SOCKET,
				ERROR_CONNECT_FAILED_CONNECT_SOCKET,
			};
	
	// Connect the socket to the host. Return value is error constant above, or ERROR_CONNECT_NONE if Ok.
	VUINT			Connect(VSTRING_CONST pszHostName)
	{
		// This must be known and valid!
		VASSERT(VSTRLEN_CHECK(pszHostName))

		// Socket should be invalid for now!
		VASSERT(m_Socket == INVALID_SOCKET)

		VUINT nResult = ERROR_CONNECT_NONE;

		// Resolve the server host name.
		HOSTENT* pHostEnt = gethostbyname(pszHostName);

		if ( pHostEnt )
		{
			// Create the socket.
			if ( (m_Socket = socket(PF_INET, SOCK_STREAM, DEFAULT_PROTOCOL)) != INVALID_SOCKET )
			{
				// Get the service information.
				SERVENT* pServEnt = getservbyname("mail", NULL);

				// Define the socket address.
				SOCKADDR_IN				sockAddr;
				sockAddr.sin_family =	AF_INET;		
				sockAddr.sin_port =		(pServEnt == NULL) ? htons(IPPORT_SMTP) : pServEnt->s_port;
				sockAddr.sin_addr =		*((IN_ADDR*)*pHostEnt->h_addr_list);
		
				// Connect the socket.
				if ( connect(m_Socket, (SOCKADDR*)&sockAddr, sizeof(sockAddr)) == 0 )
					nResult = ERROR_CONNECT_NONE;
				else
				{
					nResult = ERROR_CONNECT_FAILED_CONNECT_SOCKET;
					Disconnect();
				}
			}
			else
				nResult = ERROR_CONNECT_FAILED_ALLOC_SOCKET;
		}
		else
			nResult = ERROR_CONNECT_BAD_HOST_NAME;

		// Return result code.
		return nResult;
	}

	// Disconnect from remove mail server and free socket, as needed.
	void			Disconnect()
	{
		if ( m_Socket != INVALID_SOCKET )
		{
			closesocket(m_Socket);
			m_Socket = INVALID_SOCKET;
		}
	}

	// Return the last string we received from the server.
	VSTRING			GetLastServerString() const
		{ return (VSTRING)m_szLastServerString; }

	// Return a reference to the internal socket.
	SOCKET&			GetSocket() const
		{ return (SOCKET&)m_Socket; }

	// Is the socket valid, allocated, and connected?
	VBOOL			IsValidSocket() const
		{ return (m_Socket != INVALID_SOCKET) ? VTRUE : VFALSE; }

	// Handle entire process, except connecting/disconnecting mail server.
	VBOOL			SendAll(VSTRING_CONST pszEMailAddressFrom, VSTRING_CONST pszSubject, VSTRING_CONST pszMessage, VSTRING_CONST pszEMailAddressesTo)
	{
		// We should be connected now!
		VASSERT(IsValidSocket())

		// Do entire process of sending a mail message. Return VFALSE when first error occurs.
		VBOOL bResult = VFALSE;

		// Say hello and send from email address.
		if ( SendHello() && SendMailFrom(pszEMailAddressFrom) )
		{
			// Add recipient to email list.
			SendRecipient(pszEMailAddressesTo);

			if ( SendData() )
			{
				// Send Subject if known (Optional).
				if ( pszSubject )
					SendSubject(pszSubject);

				// Send the message body.
				SendMessage(pszMessage);
				
				// End data (message body).
				SendEndData();
				
				// Return success.
				bResult = VTRUE;
			}
			
			// Tell server we are done
			SendQuit();
		}

		return bResult;
	}

	// Tell the SMTP server we are ready to send data.
	VBOOL			SendData()
		{ return SendToMailServer("DATA\r\n"); }

	// Tell the SMTP server we are done sending data.
	VBOOL			SendEndData()
		{ return SendToMailServer("\r\n.\r\n"); }

	/* Say HELLO to the SMTP server. Returns VTRUE if server responds with OK. pszLocalHost should be like
	microsoft.com, or NULL for local name.*/
	VBOOL			SendHello(VSTRING_CONST pszLocalHost = NULL)
	{
		VString s("HELO ");

		if ( pszLocalHost )
			s += pszLocalHost;
		else
		{
			VTCHAR szHostName[DOMAIN_MAX_BUFFER_SIZE + 1];
			
			if ( gethostname(szHostName, VARRAY_SIZE(szHostName)) != SOCKET_ERROR )
				s += szHostName;
		}

		s.AppendCRLF();

		return SendToMailServer(s);
	}

	// Tell the server who this mail is from.
	VBOOL			SendMailFrom(VSTRING_CONST pszEMailAddress)
	{
		VASSERT(VSTRLEN_CHECK(pszEMailAddress))

		VString s("MAIL FROM:<");
		s += pszEMailAddress;
		s += ">";
		s.AppendCRLF();
		
		return SendToMailServer(s);
	}

	// Send the message text (body) to the server.
	VBOOL			SendMessage(VSTRING_CONST pszMessage)
		{ VASSERT(VSTRLEN_CHECK(pszMessage)) return SendToMailServer(pszMessage, VTRUE); }

	// Send the NOOP command.
	VBOOL			SendNOOP()
		{ return SendToMailServer("NOOP\r\n"); }

	// Instruct server to add this recipient.
	VBOOL			SendRecipient(VSTRING_CONST pszEMailAddress)
	{
		// This is required!
		VASSERT(pszEMailAddress)

		VString s("RCPT TO:<");
		s += pszEMailAddress;
		s += ">";
		s.AppendCRLF();

		return SendToMailServer(s);
	}

	// Send the reset command.
	VBOOL			SendReset()
		{ return SendToMailServer("RSET\r\n"); }

	/* Send the Subject of the mail message. Should be called AFTER the call to SendData() but BEFORE the call to
	SendMessage() with the embedded data.*/
	VBOOL			SendSubject(VSTRING_CONST pszSubject)
	{
		VASSERT(VSTRLEN_CHECK(pszSubject));

		// Build string.
		VString s("Subject: ");
		s += pszSubject;
		s.AppendCRLF();
		
		// Send string to server.
		return SendToMailServer(s, VFALSE);
	}

	// Tell the SMTP server we are done talking to it.
	VBOOL			SendQuit()
		{ return SendToMailServer("QUIT\r\n"); }

protected:
	// This notification function gets called when server responses are received.
	virtual void	OnNotifyServerMessage(VSTRING_CONST pszMessage)
		{;}

	/* Send a message to the server and wait for response. Return value is VTRUE if the server replies with an OK
	message. Those are defined as a reply message beginning with a 2, or 354 if sending the DATA command, which
	means the server is ready for data. The result string from the server can be retrieved with GetLastServerString().
	When sending the message (DATA) text, bMessageText should be VTRUE. This is our flag to indicate the server will
	not send response data. Since the SMTP spec requires every line sent to server to end with CRLR, this function
	checks for this and appends as needed.*/
	VBOOL			SendToMailServer(VSTRING_CONST pszCommand, VBOOL bMessageText = VFALSE)
	{
		// String must be known!
		VASSERT(VSTRLEN_CHECK(pszCommand))

		// Assume failure.
		VBOOL bResult = VFALSE;

		// Verify pszCommand has final \r\n as required by spec.
		VINT			nLen =			VSTRLEN(pszCommand);
		VSTRING_CONST	pszTerminate =	(nLen >= 2) ? pszCommand + nLen - 2 : NULL;
		VBOOL			bValidString =	VTRUE;

		// Only used if we need to allocate the string.
		VString strSend;
		
		if ( !pszTerminate || VSTRCMP(pszTerminate, "\r\n") != 0 )
		{
			// We need to add CRLF pair.
			strSend = pszCommand;
			strSend.AppendCRLF();
			pszCommand = strSend;
			
			if ( strSend.GetErrorCount() )
				bValidString = VFALSE;
		}

		if ( bValidString )
		{
			// Send the string to the server.
			if ( send(m_Socket, pszCommand, VSTRLEN(pszCommand), 0) != SOCKET_ERROR )
			{
				// If bMessageText is VTRUE, the server will not send us a response back.
				if ( !bMessageText )
				{
					// Get info from the server.
					VINT nReceived = recv(m_Socket, m_szLastServerString, VARRAY_SIZE(m_szLastServerString), 0);

					if ( nReceived && nReceived != SOCKET_ERROR )
					{
						// Verify termination.
						m_szLastServerString[nReceived] = '\0';

						// Check for error.
						if ( m_szLastServerString[0] == '2' || m_szLastServerString[0] == '3' )
							bResult = VTRUE;
						
						// Call notification function.
						OnNotifyServerMessage(m_szLastServerString);
					}
				}
				else
					bResult = VTRUE;
			}
		}

		return bResult;
	}

	// Embedded Member(s).
	SOCKET			m_Socket;
	VTCHAR			m_szLastServerString[SMTP_MAX_REPLY_BUFFER_SIZE];
};

#endif // VSMTPSOCKET
