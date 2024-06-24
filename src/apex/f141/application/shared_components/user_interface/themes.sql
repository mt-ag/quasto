prompt --application/shared_components/user_interface/themes
begin
--   Manifest
--     THEME: 141
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.6'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_shared.create_theme(
 p_id=>wwv_flow_imp.id(50847754929675176)
,p_theme_id=>42
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>4070917134413059350
,p_is_locked=>false
,p_default_page_template=>wwv_flow_imp.id(50697309438675094)
,p_default_dialog_template=>wwv_flow_imp.id(50676865440675088)
,p_error_template=>wwv_flow_imp.id(50678388644675089)
,p_printer_friendly_template=>wwv_flow_imp.id(50697309438675094)
,p_breadcrumb_display_point=>'REGION_POSITION_01'
,p_sidebar_display_point=>'REGION_POSITION_02'
,p_login_template=>wwv_flow_imp.id(50678388644675089)
,p_default_button_template=>wwv_flow_imp.id(50844813129675167)
,p_default_region_template=>wwv_flow_imp.id(50780356327675132)
,p_default_chart_template=>wwv_flow_imp.id(50780356327675132)
,p_default_form_template=>wwv_flow_imp.id(50780356327675132)
,p_default_reportr_template=>wwv_flow_imp.id(50780356327675132)
,p_default_tabform_template=>wwv_flow_imp.id(50780356327675132)
,p_default_wizard_template=>wwv_flow_imp.id(50780356327675132)
,p_default_menur_template=>wwv_flow_imp.id(50742240389675118)
,p_default_listr_template=>wwv_flow_imp.id(50780356327675132)
,p_default_irr_template=>wwv_flow_imp.id(50728801114675111)
,p_default_report_template=>wwv_flow_imp.id(50807155826675144)
,p_default_label_template=>wwv_flow_imp.id(50842276801675164)
,p_default_menu_template=>wwv_flow_imp.id(50846334662675169)
,p_default_calendar_template=>wwv_flow_imp.id(50846519853675170)
,p_default_list_template=>wwv_flow_imp.id(50840405450675161)
,p_default_nav_list_template=>wwv_flow_imp.id(50831347357675158)
,p_default_top_nav_list_temp=>wwv_flow_imp.id(50831347357675158)
,p_default_side_nav_list_temp=>wwv_flow_imp.id(50829566706675157)
,p_default_nav_list_position=>'SIDE'
,p_default_dialogbtnr_template=>wwv_flow_imp.id(50733389987675114)
,p_default_dialogr_template=>wwv_flow_imp.id(50790142840675136)
,p_default_option_label=>wwv_flow_imp.id(50842276801675164)
,p_default_required_label=>wwv_flow_imp.id(50843572694675165)
,p_default_navbar_list_template=>wwv_flow_imp.id(50832393461675159)
,p_file_prefix => nvl(wwv_flow_application_install.get_static_theme_file_prefix(42),'#APEX_FILES#themes/theme_42/22.2/')
,p_files_version=>64
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APEX_FILES#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_FILES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>'#THEME_FILES#css/Core#MIN#.css?v=#APEX_VERSION#'
);
wwv_flow_imp.component_end;
end;
/
