<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			
		</doc:purpose>
		<doc:context>
			
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template match="H2G2[@TYPE = 'MESSAGEBOARDADMIN'] | H2G2[@TYPE = 'FRONTPAGE']" mode="page">
		<div class="left">
			<h2>Welcome</h2>
			<p>Welcome to the messageboard admin, from here you can create a new messageboard, or edit/update an existing one.</p>
			<p>If you are setting up a new messageboard for the first time, please read this short guide, outlining what steps you need to take: </p>
			<p>
				<a href="#">New Messageboard Guide</a>
			</p>
			<p class="info">If you need additional help, please contact <a href="mailto:communities@bbc.co.uk">DNA Host Support</a></p>
		</div>
		<div class="main">
			<h2>Messageboard Admin</h2>
			<p>The controls below allow you to set the various admin-based options for your messageboard. If you wish to change the design of your messageboard, select the <strong>Design</strong> tab.</p>
			<div class="left half">
				<h3>GENERAL</h3>
				<h4>OPENING HOURS</h4>
				<p>
					Control the times when people can comment on the messageboard.
				</p>
				<p>
					<a href="{$root}/MessageBoardSchedule">Edit opening hours</a>
				</p>
				<h4>EMOTICONS</h4>
				<p>The messageboard has a default set of emoticons, but you can choose to add your own.</p>
				<p>
					<a href="#">Add emoticons set</a>
				</p>
			</div>
			<div class="left half">
				<h3>TOPICS</h3>
				<h4>ARCHIVE TOPICS</h4>
				<p>Choose to archive selected topics.</p>
				<p>
					<a href="#">Archive topics</a>
				</p>
				<h3>DEVELOPMENT</h3>
				<h4>ASSETS</h4>
				<p>Choose to add your own custom CSS and images to your messageboard.</p>
				<p>
					<a href="#">Add/edit assets</a>
				</p>
			</div>
			<div class="clear topborder">
				<div class="left half">
					<p class="button">
						<a href="#" class="button">Publish your messageboard</a>
					</p>
					<p class="info">
						Alternatively, to view your messageboard exactly as the user will view it, <a href="#">preview your messageboard</a>.
					</p>
				</div>
				<div class="left half">
					<p class="button">
						<a href="{$root}/frontpagelayout?s_mode=design" class="button">Change the design of your messageboard</a>
					</p>
				</div>
			</div>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
