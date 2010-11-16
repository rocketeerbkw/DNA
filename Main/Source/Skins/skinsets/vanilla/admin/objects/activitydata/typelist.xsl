<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
	<xsl:template match="SELECTEDTYPES" mode="objects_activitydata_typelist" >
		<ul class="dna-fl">
			<li>
				<input type="checkbox" name="s_eventtype" id="all" value="0">
					<xsl:if test="TYPEID[text() = 0] or count(TYPEID) = 0">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="all">All</label>
			</li>
			<li>
				<input type="checkbox" name="s_eventtype" id="failed_posts" value="1">
					<xsl:if test="TYPEID[text() = 1]">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="failed_posts">Failed Posts</label>
			</li>
			<li>
				<input type="checkbox" name="s_eventtype" id="referred_posts" value="2">
					<xsl:if test="TYPEID[text() = 2]">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="referred_posts">Referred Posts</label>
			</li>
		</ul>
		<ul class="dna-fl">
			<li>
				<input type="checkbox" name="s_eventtype" id="failed_articles" value="3">
					<xsl:if test="TYPEID[text() = 3]">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="failed_articles">Failed Articles</label>
			</li>
			<li>
				<input type="checkbox" name="s_eventtype" id="referred_articles" value="4">
					<xsl:if test="TYPEID[text() = 4]">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="referred_articles">Referred Articles</label>
			</li>
			<li>
				<input type="checkbox" name="s_eventtype" id="alerts_posts" value="7">
					<xsl:if test="TYPEID[text() = 7]">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="alerts_posts">Alerted posts</label>
			</li>
		</ul>
		<ul class="dna-fl">
			<li>
				<input type="checkbox" name="s_eventtype" id="alert_articles" value="8">
					<xsl:if test="TYPEID[text() = 8]">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="alert_articles">Alerted articles</label>
			</li>
			<li>
				<input type="checkbox" name="s_eventtype" id="premod_users" value="10">
					<xsl:if test="TYPEID[text() = 10]">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="premod_users">Pre-moderated users</label>
			</li>
			<li>
				<input type="checkbox" name="s_eventtype" id="postmod_users" value="11">
					<xsl:if test="TYPEID[text() = 11]">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="postmod_users">Post-moderated users</label>
			</li>
		</ul>
		<ul class="dna-fl">
			<li>
				<input type="checkbox" name="s_eventtype" id="banned_users" value="12">
					<xsl:if test="TYPEID[text() = 12]">
						<xsl:attribute name="checked">
						<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="banned_users">Banned users</label>
			</li>
			<li>
				<input type="checkbox" name="s_eventtype" id="deactivated_users" value="13">
					<xsl:if test="TYPEID[text() = 13]">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="deactivated_users">Deactivated users</label>
			</li>
			<li>
				<input type="checkbox" name="s_eventtype" id="new_users" value="14">
					<xsl:if test="TYPEID[text() = 14]">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<label for="new_users">New users</label>
			</li>
		</ul>
	</xsl:template>
</xsl:stylesheet>