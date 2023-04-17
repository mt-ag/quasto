set define '~'
set concat on
set concat .
set verify off
-- Small Wrapper script to call to import a row from qa_import_files into the qa_rules table
-- Argument 1 is the ID of the inserted clob_file into qa_import_files passed from the import_file_to_rules_json
Begin
  qa_export_import_rules_pkg.p_import_clob_to_rules_table(pi_qaif_id => ~1);
end;
/