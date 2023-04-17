var DBUtil = Java.type("oracle.dbtools.db.DBUtil");
var import_flag = args[2];
print(java.nio.file.Paths.get(".").toAbsolutePath().normalize().toString());
/*
/*
*  Function to take in a filename and add or create it to a map
*  with bind variables
*/
function addBindToMap(map,bindName,fileName){
    /*  conn is the actual JDBC connection */
    var b = conn.createBlob();

    var out = b.setBinaryStream(1);

    var path = java.nio.file.FileSystems.getDefault().getPath("",fileName);

    /* slurp the file over to the blob */
    java.nio.file.Files.copy(path, out);
    out.flush();

    if ( map == null ) {
        /* java objects as binds needs a hashmap */
        var HashMap = Java.type("java.util.HashMap");
        map = new HashMap();
    }
    /* put the bind into the map */
    map.put("b",b);
return map;
}

/* File name */
var l_filename = args[1];
var ext = '.' + l_filename.split('.').pop();
var mime=""
switch (ext){
  case '.js' :
    mime = 'application/javascript'
    break;
  case '.sql' :
    mime = 'application/sql'
    break;
  case '.log' :
    mime = 'plain/text'
    break;
    case '.json' :
        mime = 'application/json'
        break;
  default:
    mime = 'application/octet'
}
/* load binds */
binds = addBindToMap(null,"b",l_filename);
/* add more binds */
binds.put("filename",l_filename);
binds.put("mime",mime);

sql = "insert into qa_import_files(qaif_filename,qaif_mimetype,qaif_clob_data)values(:filename,:mime,to_clob(:b))";

// String array of returning columns
retCols = Java.to(["QAIF_ID",],"java.lang.String[]");

// prep passing return cols
var ps = conn.prepareStatement(sql,retCols);
// helper class to do the binds
 DBUtil.bind(ps,binds);

 // execute
if (ps.executeUpdate() > 0) {

    // getGeneratedKeys() returns result set of keys that were auto
    var generatedKeys = ps.getGeneratedKeys();

    // generatedKeys is a resultSet when import_flag == 1 then import the file directly into the db
    if (null != generatedKeys && generatedKeys.next() &&  (import_flag == 1) ){
        // data type of return    
        binds.put("QAIF_ID",generatedKeys.getInt(1));
        sql_import = "@import_qa_import_file_to_qa_rules.sql " + binds.get("QAIF_ID");
        sqlcl.setStmt(sql_import);
        sqlcl.run();
        
    }
}

/* print the results */
sqlcl.setStmt("select qaif_id,qaif_filename,qaif_created_on,qaif_mimetype from qa_import_files order by qaif_created_on desc;");
sqlcl.run();
/* Commit at the  End*/
sqlcl.setStmt("commit;");
sqlcl.run();