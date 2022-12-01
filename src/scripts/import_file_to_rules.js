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

    var path = java.nio.file.FileSystems.getDefault().getPath("","qa_rules_mt_ag_ddl.json");

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
var dir =  args[2];
var l_filename = args[1];
var filepath = "qa_rules_mt_ag_ddl.json"
var ext = '.' + l_filename.split('.')[1];
print (filepath);
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
/*"quasto.qa_export_import_rules_pkg.f_import_clob_to_qa_import_files(pi_clob => :b ,pi_filename => :filename ,pi_mimetype => :mime);",*
/* add more binds */
binds.put("filename",l_filename);
binds.put("mime",mime);
binds.put("return_id","TEST");

var sql = [
    "begin",    
    /*"quasto.qa_export_import_rules_pkg.f_import_clob_to_qa_import_files(pi_clob => :b ,pi_filename => :filename ,pi_mimetype => :mime);",*/
    "insert into qa_import_files(qaif_filename,qaif_mimetype,qaif_clob_data)values(:filename,:mime,to_clob(:b)) returning qaif_id into :return_id;",
    "end;"
].join("\n");
/* exec the insert and pass binds */
var ret = util.execute(sql,binds);
print(binds.get("return_id"));

/* print the results */
sqlcl.setStmt("select qaif_id,qaif_filename,qaif_created_on,qaif_mimetype from qa_import_files order by qaif_created_on desc;");

if (!ret){
    ctx.write("ERROR\n");
    ctx.write(util.getLastException());
    ctx.write("\n");
  }

sqlcl.run();