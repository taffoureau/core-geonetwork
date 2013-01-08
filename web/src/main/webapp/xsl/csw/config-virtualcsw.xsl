<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	

	<xsl:include href="../main.xsl"/>

	
	<xsl:template name="content">
		<xsl:call-template name="formLayout">
			<xsl:with-param name="title" select="/root/gui/strings/virtualcswServerConfig"/>
			<xsl:with-param name="content">
				<xsl:call-template name="form"/>
			</xsl:with-param>
			<xsl:with-param name="buttons">
				<button class="content" onclick="load('{/root/gui/locService}/admin')"><xsl:value-of select="/root/gui/strings/back"/></button>
				&#160;
				<button class="content" onclick="load('{/root/gui/locService}/virtualcsw.config.get')">
					<xsl:value-of select="/root/gui/strings/virtualcswNewService"/></button>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
	
	
	<xsl:template name="form">
	
		<script type="text/javascript">
			function deleteUser(service, message, id){
				var cswContactId = '<xsl:value-of select="/root/gui/env/csw/contactId"/>';
				if (id == cswContactId) {
					if (!confirm("<xsl:value-of select="/root/gui/strings/delUserCsw"/>"))
						return null;
				}
				doConfirm(service, message);
			}
		</script>
		
		<table border="0">
			<tr>
				<th class="padded" style="width:100px;"><b><xsl:value-of select="/root/gui/strings/virtualcswServiceName"/></b></th>
				<th class="padded" style="width:100px;"><b><xsl:value-of select="/root/gui/strings/virtualcswClassName"/></b></th>
				<th class="padded" style="width:100px;"><b><xsl:value-of select="/root/gui/strings/virtualcswParamName"/></b></th>
				<th class="padded" style="width:100px;"><b><xsl:value-of select="/root/gui/strings/virtualcswParamValue"/></b></th>
				<th class="padded"><b><xsl:value-of select="/root/gui/strings/operation"/></b></th>
			</tr>
			
			
			
			<xsl:for-each select="/root/gui/services/record">
			
				<xsl:sort select="name"/>
				
				<!-- 
				<xsl:variable name="profileId">
					<xsl:value-of select="profile"/>
				</xsl:variable>
				-->
				
				<tr>
					<td class="padded"><xsl:value-of select="name"/></td>
					<td class="padded"><xsl:value-of select="class"/></td>
					
					<td class="padded"></td>
					<td class="padded"></td>
					
					<!--  <td class="padded"><xsl:value-of select="/root/gui/strings/profileChoice[@value=$profileId]"/></td>-->
					
					<td class="padded">
						<button class="content" onclick="load('{/root/gui/locService}/virtualcsw.config.edit?id={id}')">
							<xsl:value-of select="/root/gui/strings/edit"/>
						</button>
						&#160;
						<!-- <button class="content" onclick="deleteUser('{/root/gui/locService}/user.remove?id={id}','{/root/gui/strings/delUserConf}', {id})">-->
						<button class="content" onclick="load('{/root/gui/locService}/virtualcsw.config.delete?id={id}')">	
							<xsl:value-of select="/root/gui/strings/delete"/>
						</button>
						
					</td>
				</tr>
			</xsl:for-each>
			
		</table>
	</xsl:template>
</xsl:stylesheet>
