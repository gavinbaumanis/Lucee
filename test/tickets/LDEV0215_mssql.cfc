component extends="org.lucee.cfml.test.LuceeTestCase" labels="mssql" {

	function isMsSqlNotSupported() {
		var msSql = msSqlCredentials();
		return isEmpty(msSql);
	}

	function run( testResults , testBox ) {
		describe( title="Test suite for LDEV-215", body=function() {
			it( title='Checking MsSQL, INDEX for the client/session storage table',skip=isMsSqlNotSupported(),body=function( currentSpec ) {
				var uri = createURI("LDEV0215");
				var result = _InternalRequest(
					template:"#uri#/mssql/mssql.cfm"
				);
				// do it twice coz client data gets written out after the request
				result = _InternalRequest(
					template:"#uri#/mssql/mssql.cfm"
				);
				expect(result.fileContent.trim()).toBe(
					'{"SESSION":[{"name":"ix_cf_session_data"},{"name":"ix_cf_session_data_expires"}],'
					& '"CLIENT":[{"name":"ix_cf_client_data"},{"name":"ix_cf_client_data_expires"}]}'
				);
			});
		});
	}

	// Private functions
	private string function createURI(string calledName){
		var baseURI = "/test/#listLast(getDirectoryFromPath(getCurrenttemplatepath()),"\/")#/";
		return baseURI & "" & calledName;
	}

	private struct function msSqlCredentials() {
		// getting the credentials from the environment variables
		return server.getDatasource("mssql");
	}
}