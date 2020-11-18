CREATE OR REPLACE PACKAGE PKG_COMMON
AS
   TYPE Cursor_Data IS REF CURSOR;

   PROCEDURE GetLookupMaster (pModuleId           LookupMaster.ModuleId%TYPE,
                              oLookupTables   OUT PKG_COMMON.CURSOR_DATA);

   PROCEDURE GetLookup (
      pLookupTableName         LookupMaster.LookupTableName%TYPE,
      pLookupColumnNames       LookupMaster.LookupColumnNames%TYPE,
      pFilter                  LookupMaster.FILTER%TYPE,
      oLookup              OUT PKG_COMMON.CURSOR_DATA);

   PROCEDURE GetMenus (oUserId   IN     Ora_Aspnet_Users.USERNAME%TYPE,
                       oMenus       OUT PKG_COMMON.CURSOR_DATA);

   PROCEDURE GetMenuItems (oUserId      IN     Ora_Aspnet_Users.USERNAME%TYPE,
                           oMenuItems      OUT PKG_COMMON.CURSOR_DATA);

   PROCEDURE GetTaskForRoles (oRole   IN     ORA_ASPNET_ROLES.ROLENAME%TYPE,
                              oTask      OUT PKG_COMMON.CURSOR_DATA);


   PROCEDURE GetAppParameters (oAppParameterTable OUT PKG_COMMON.CURSOR_DATA);

   PROCEDURE GetMENUserDetails (
      pADUserId         IN     ORA_ASPNET_USERS.USERNAME%TYPE,
      oMENUserDetails      OUT PKG_COMMON.CURSOR_DATA);

   PROCEDURE GetProfileCatalogTags (
      pADUserId             IN     ORA_ASPNET_USERS.USERNAME%TYPE,
      oProfileCatalogTags      OUT PKG_COMMON.CURSOR_DATA);

   PROCEDURE GetSystemDepartments (oSystemDept OUT PKG_COMMON.CURSOR_DATA);

   PROCEDURE AuditUserSession (
      USERNAME       IN     audit_user_sessions.username%TYPE,
      MACHINE        IN     audit_user_sessions.machine%TYPE,
      CLIENT_INFO    IN     audit_user_sessions.client_info%TYPE,
      IS_DELETED     IN     audit_user_sessions.is_deleted%TYPE,
      UPDATE_COUNT   IN     audit_user_sessions.update_count%TYPE,
      O_STATUSFLAG      OUT NUMBER);

   PROCEDURE GetSelectedLookup (
      pModuleId       IN     lookupmaster.MODULEID%TYPE,
      pLookupType     IN     lookupmaster.LOOKUPTYPENAME%TYPE,
      oLookupTables      OUT PKG_COMMON.CURSOR_DATA);

   PROCEDURE PRC_SERVICE_AUDIT (
      I_USER_NAME      IN SERVICE_AUDIT.USER_NAME%TYPE,
      I_SERVICE_NAME   IN SERVICE_AUDIT.SERVICE_NAME%TYPE,
      I_METHOD_NAME    IN SERVICE_AUDIT.METHOD_NAME%TYPE,
      I_START_TIME     IN SERVICE_AUDIT.START_TIME%TYPE,
      I_END_TIME       IN SERVICE_AUDIT.END_TIME%TYPE);

   PROCEDURE GETCONTROLSFORROLE (
      I_ROLE       IN     CLOB,
      O_CONTROLS      OUT PKG_COMMON.CURSOR_DATA);

   /*Added by Swapnali Belose for SVOD Enhancements_[20.04.2015]*/
   PROCEDURE prc_lookup_user_service (
      i_user_id   IN     x_user_service_map.x_usm_user_id%TYPE,
      o_cursor       OUT pkg_common.cursor_data);

   --18-Jun-2015:3rd party CP CR:Jawahar : Added SP for mapping base access for user
   PROCEDURE prc_cp_media_ser_lk (
      i_user_id   IN     x_user_service_map.x_usm_user_id%TYPE,
      o_cursor       OUT pkg_common.cursor_data);

   --[Pravin][20150805] - Implementation of Translated Genre lookup.
   PROCEDURE PRC_LOOKUP_GET_TRANS_GENRE (
      I_LANG_ID   IN     X_TBL_MM_LANGUAGES.LANG_ID%TYPE,
      O_REF_CUR      OUT PKG_COMMON.CURSOR_DATA);

   PROCEDURE x_prc_cont_distr_lookup (
      i_rel_entity       IN     VARCHAR2,
      i_owner_licensee          VARCHAR2,
      o_rel_for             OUT SYS_REFCURSOR);

   /* procedure x_prc_edit_suit_area_search(i_user_id      IN VARCHAR2
                                         ,o_edit_suite      OUT sys_refcursor
                                         );*/

   PROCEDURE x_prc_edit_suit_area_ate (i_user_id      IN     VARCHAR2,
                                       o_edit_suite      OUT SYS_REFCURSOR);

   PROCEDURE x_prc_edit_suit_area_uids (i_user_id      IN     VARCHAR2,
                                        o_edit_suite      OUT SYS_REFCURSOR);

   ---Added By Rashmi For Svod For Deal:RDT  :start
   PROCEDURE PRC_LOOKUP_LOAD_DEAL (
      i_release_for   IN     VARCHAR2,
      O_REF_CUR          OUT PKG_COMMON.CURSOR_DATA);
---Added By Rashmi For Svod For Deal:RDT


END PKG_COMMON;
/
CREATE OR REPLACE PACKAGE BODY PKG_COMMON
AS
   PROCEDURE GetLookupMaster (pModuleId           LookupMaster.ModuleId%TYPE,
                              oLookupTables   OUT PKG_COMMON.CURSOR_DATA)
   AS
   BEGIN
      OPEN oLookupTables FOR
         SELECT LOOKUPMASTERID,
                ModuleId,
                LookupTableName,
                LookupColumnNames,
                LookupTypeName,
                LookupItemTypeName,
                Filter
           FROM LookupMaster
          WHERE ModuleId = pModuleId;
   END GetLookupMaster;

   PROCEDURE GetLookup (
      pLookupTableName         LookupMaster.LookupTableName%TYPE,
      pLookupColumnNames       LookupMaster.LookupColumnNames%TYPE,
      pFilter                  LookupMaster.FILTER%TYPE,
      oLookup              OUT PKG_COMMON.CURSOR_DATA)
   AS
      sqlStmntSelect   VARCHAR2 (1500) := 'SELECT ';
   BEGIN
      IF pLookupColumnNames IS NULL
      THEN
         sqlStmntSelect := sqlStmntSelect || ' * FROM ';
      ELSE
         sqlStmntSelect := sqlStmntSelect || pLookupColumnNames || ' FROM ';
      END IF;

      IF pfilter IS NULL
      THEN
         sqlStmntSelect := sqlStmntSelect || pLookupTableName;
      ELSE
         sqlStmntSelect :=
            sqlStmntSelect || pLookupTableName || ' Where ' || pfilter;
      END IF;

      OPEN oLookup FOR sqlStmntSelect;
   END GetLookup;

   PROCEDURE GetMenus (oUserId   IN     Ora_Aspnet_Users.USERNAME%TYPE,
                       oMenus       OUT PKG_COMMON.CURSOR_DATA)
   AS
   BEGIN
      OPEN oMenus FOR
         SELECT MENUID,
                MENUNAME,
                CAPTION,
                MODULEID
           FROM MENU;
   --where Menuid in(
   --select Distinct (MenuId) from menurole
   --where roleid in (
   --select roleid from ORA_ASPNET_USERSINROLES
   --where userid =(
   --select  UserId from ORA_ASPNET_USERS
   --where loweredUserName = oUserId )));
   END;

   -- END GetMenus;

   PROCEDURE GetMenuItems (oUserId      IN     Ora_Aspnet_Users.USERNAME%TYPE,
                           oMenuItems      OUT PKG_COMMON.CURSOR_DATA)
   AS
   BEGIN
      OPEN oMenuItems FOR
           SELECT MENUITEMID,
                  MENUITEMNAME,
                  CAPTION,
                  MENUID,
                  PARENTID,
                  FWK_TASK.TASKNAME
             FROM    MENUITEM
                  LEFT OUTER JOIN
                     FWK_TASK
                  ON MENUITEM.TASKID = FWK_TASK.ID
         ORDER BY MENUITEM.MENUITEMID;
   --        where menuitemid in(
   --select MenuItemId from menurole
   --where roleid in(
   --select roleid from ORA_ASPNET_USERSINROLES
   --where userid = (
   --select  UserId from ORA_ASPNET_USERS where UserName=oUserId)))
   --or
   --menuid in(
   --select MenuId from menurole
   --where roleid in(
   --select roleid from ORA_ASPNET_USERSINROLES
   --where userid = (
   --select  UserId from ORA_ASPNET_USERS
   --where loweredUserName = oUserId))) ;

   END;

   -- END GetMenuItems;

   PROCEDURE GetTaskForRoles (oRole   IN     ORA_ASPNET_ROLES.ROLENAME%TYPE,
                              oTask      OUT PKG_COMMON.CURSOR_DATA)
   AS
   BEGIN
      OPEN oTask FOR
         SELECT FWK_TASK.TASKNAME, FWK_TASK.DESCRIPTION, FWK_TASK.ID
           FROM    FWK_TASK
                JOIN
                   FWK_ROLETASK
                ON FWK_TASK.ID = FWK_ROLETASK.TASKID
          WHERE FWK_ROLETASK.ROLEID =
                   (SELECT RoleId
                      FROM ORA_ASPNET_ROLES
                     WHERE ORA_ASPNET_ROLES.LOWEREDROLENAME = LOWER (oRole));
   END;

   -- END GetTaskForRoles


   PROCEDURE GetAppParameters (oAppParameterTable OUT PKG_COMMON.CURSOR_DATA)
   AS
   BEGIN
      OPEN oAppParameterTable FOR
         SELECT "KEY", "Content" FROM FWK_APPPARAMETER;
   END GetAppParameters;


   PROCEDURE GetMENUserDetails (
      pADUserId         IN     ORA_ASPNET_USERS.USERNAME%TYPE,
      oMENUserDetails      OUT PKG_COMMON.CURSOR_DATA)
   AS
   BEGIN
      /* Added Id =6 in x_fin_configs for 5+2 Costing and Fetching it to UI common procedure so that it can be
      used across all modules at screen load. Pranay Kusumwal 11/04/2014 */

      /*   OPEN OMENUSERDETAILS FOR
            SELECT men_user.*, x_fin_configs.CONTENT "Go_Live_Date"
              FROM MEN_USER, x_fin_configs
             WHERE LOWER (usr_ad_loginid) = LOWER (pADUserId) AND id = 6;*/

      OPEN OMENUSERDETAILS FOR
         SELECT men_user.*,
                x_fin_configs.CONTENT "Go_Live_Date",
                key--DEV.R10:Acquisition:Start[Ref with BR_15_243]_[Nasreen Mulla]_[23-09-2015]
                ,
                (SELECT CONCAT_COLUMN (ucm_cha_cluster)
                   FROM x_user_cha_cluster_map
                  WHERE ucm_usr_id = usr_id)
                   ucm_cha_cluster
           --DEV.R10:Acquisition:End
           FROM MEN_USER, x_fin_configs
          WHERE LOWER (usr_ad_loginid) = LOWER (pADUserId) AND id in (1,13,6,9,11)/*Added 10 for CU4ALL GO LIVE DATE*/
            --BR_16_400 - Restriction on updating the License Start Date to prior 01-Jun-2013 v1.0:[JAWAHAR GARG][ADDED 1 IN ID]
          ;
   END GetMENUserDetails;

   PROCEDURE GetProfileCatalogTags (
      pADUserId             IN     ORA_ASPNET_USERS.USERNAME%TYPE,
      oProfileCatalogTags      OUT PKG_COMMON.CURSOR_DATA)
   AS
      sUSERID   ORA_ASPNET_USERS.USERID%TYPE;
   BEGIN
      SELECT USERID
        INTO sUSERID
        FROM ORA_ASPNET_USERS
       WHERE LOWER (ORA_ASPNET_USERS.USERNAME) = LOWER (pADUserId);

      OPEN oProfileCatalogTags FOR
           SELECT TAG
             FROM FWK_PROFILECATALOGTAG
            WHERE moduleid IN (SELECT DISTINCT moduleid
                                 FROM menu
                                      INNER JOIN menuitem
                                         ON menu.menuid = menuitem.menuid
                                      INNER JOIN fwk_roletask
                                         ON menuitem.taskid =
                                               fwk_roletask.taskid
                                      INNER JOIN ora_aspnet_usersinroles
                                         ON fwk_roletask.roleid =
                                               ora_aspnet_usersinroles.roleid
                                WHERE ora_aspnet_usersinroles.Userid = sUSERID)
         ORDER BY tagid;
   END GetProfileCatalogTags;

   PROCEDURE GetSystemDepartments (oSystemDept OUT PKG_COMMON.CURSOR_DATA)
   AS
   BEGIN
      OPEN oSystemDept FOR
           SELECT mco_value, mco_desc
             FROM men_code
            WHERE mco_type = 'DEP_ID' AND mco_value != 'HEADER'
         ORDER BY mco_value;
   END GetSystemDepartments;

   PROCEDURE AuditUserSession (
      USERNAME       IN     audit_user_sessions.username%TYPE,
      MACHINE        IN     audit_user_sessions.machine%TYPE,
      CLIENT_INFO    IN     audit_user_sessions.client_info%TYPE,
      IS_DELETED     IN     audit_user_sessions.is_deleted%TYPE,
      UPDATE_COUNT   IN     audit_user_sessions.update_count%TYPE,
      O_STATUSFLAG      OUT NUMBER)
   AS
   BEGIN
      O_STATUSFLAG := -1;

      INSERT INTO audit_user_sessions (USERNAME,
                                       MACHINE,
                                       CLIENT_INFO,
                                       LOGON_TIME,
                                       IS_DELETED,
                                       UPDATE_COUNT)
           VALUES (USERNAME,
                   MACHINE,
                   CLIENT_INFO,
                   SYSDATE,
                   0,
                   0);

      COMMIT;
      O_STATUSFLAG := 1;
   END AuditUserSession;

   PROCEDURE GetSelectedLookup (
      pModuleId       IN     lookupmaster.MODULEID%TYPE,
      pLookupType     IN     lookupmaster.LOOKUPTYPENAME%TYPE,
      oLookupTables      OUT PKG_COMMON.CURSOR_DATA)
   AS
      l_LookupTableName      lookupmaster.LookupTableName%TYPE;
      l_LookupColumnNames    lookupmaster.LookupColumnNames%TYPE;
      l_LookupItemTypeName   lookupmaster.lookupitemtypename%TYPE;
      l_Filter               lookupmaster.Filter%TYPE;
      sqlStmntSelect         VARCHAR2 (1500);
   BEGIN
      SELECT LookupTableName,
             LookupColumnNames,
             lookupitemtypename,
             Filter
        INTO l_LookupTableName,
             l_LookupColumnNames,
             l_LookupItemTypeName,
             l_Filter
        FROM LookupMaster
       WHERE ModuleId = pModuleId AND LOOKUPTYPENAME = pLookupType;

      sqlStmntSelect := 'SELECT ''' || l_LookupItemTypeName || ''',  ';

      IF l_LookupColumnNames IS NULL
      THEN
         sqlStmntSelect := sqlStmntSelect || ' * FROM ';
      ELSE
         sqlStmntSelect := sqlStmntSelect || l_LookupColumnNames || ' FROM ';
      END IF;

      IF l_Filter IS NULL
      THEN
         sqlStmntSelect := sqlStmntSelect || l_LookupTableName;
      ELSE
         sqlStmntSelect :=
            sqlStmntSelect || l_LookupTableName || ' Where ' || l_Filter;
      END IF;
      OPEN oLookupTables FOR sqlStmntSelect;
   END GetSelectedLookup;


   PROCEDURE PRC_SERVICE_AUDIT (
      I_USER_NAME      IN SERVICE_AUDIT.USER_NAME%TYPE,
      I_SERVICE_NAME   IN SERVICE_AUDIT.SERVICE_NAME%TYPE,
      I_METHOD_NAME    IN SERVICE_AUDIT.METHOD_NAME%TYPE,
      I_START_TIME     IN SERVICE_AUDIT.START_TIME%TYPE,
      I_END_TIME       IN SERVICE_AUDIT.END_TIME%TYPE)
   AS
      l_ID   NUMBER := 0;
   BEGIN
      SELECT NVL (MAX (id), 0) + 1 INTO l_id FROM service_audit;

      INSERT INTO service_audit (ID,
                                 USER_NAME,
                                 METHOD_NAME,
                                 SERVICE_NAME,
                                 START_TIME,
                                 END_TIME)
           VALUES (l_id,
                   I_USER_NAME,
                   I_METHOD_NAME,
                   I_SERVICE_NAME,
                   I_START_TIME,
                   I_END_TIME);

      COMMIT;
   END PRC_SERVICE_AUDIT;

   PROCEDURE GETCONTROLSFORROLE (
      I_ROLE       IN     CLOB,
      O_CONTROLS      OUT PKG_COMMON.CURSOR_DATA)
   AS
   BEGIN
      OPEN O_CONTROLS FOR
         SELECT DISTINCT
                FWK_TASK.TASKNAME,
                GETDISABLECONTROLS (FWK_ROLETASK.ID) DISABLE_CONTROLS,
                GETHIDECONTROLS (FWK_ROLETASK.ID) HIDE_CONTROLS
           FROM FWK_TASK, FWK_ROLETASK, FWK_ROLETASKFIELD
          WHERE     FWK_TASK.ID = FWK_ROLETASK.TASKID
                AND FWK_ROLETASK.ID = FWK_ROLETASKFIELD.ROLETASKID
                AND FWK_ROLETASK.ROLEID IN (SELECT ROLEID
                                              FROM ORA_ASPNET_ROLES
                                             WHERE INSTR (
                                                      I_ROLE,
                                                      ','
                                                      || ORA_ASPNET_ROLES.LOWEREDROLENAME
                                                      || ',') > 0);
   END;

  PROCEDURE prc_lookup_user_service
  (
    i_user_id   IN  x_user_service_map.x_usm_user_id%TYPE,
    o_cursor    OUT pkg_common.cursor_data
  )
  AS
  BEGIN
    open O_CURSOR for
     --Start 18-Jun-2015:3rd party CP CR:Jawahar : Added parent media servie column in ms_media_service_parent
    /*SELECT x_usm_id
           ,x_usm_media_service_code
           ,(SELECT ms_media_service_flag FROM
            sgy_pb_media_service WHERE ms_media_service_code = x_usm_media_service_code) Media_flag
           ,x_usm_usr_role
      FROM x_user_service_map
     WHERE UPPER(x_usm_user_id) = UPPER(i_user_id);*/

         SELECT x_usm_id,
                X_USM_MEDIA_SERVICE_CODE,
                ms_media_service_flag AS Media_flag,
                X_USM_USR_ROLE,
                ms_media_service_parent
           FROM X_USER_SERVICE_MAP F1, SGY_PB_MEDIA_SERVICE F2
          WHERE F2.MS_MEDIA_SERVICE_CODE = F1.X_USM_MEDIA_SERVICE_CODE
                AND UPPER (X_USM_USER_ID) = UPPER (I_USER_ID);
   --END 18-Jun-2015:3rd party CP CR:Jawahar :
   END prc_lookup_user_service;

   --18-Jun-2015:3rd party CP CR:Jawahar : Added SP for mapping base access for user
   PROCEDURE prc_cp_media_ser_lk (
      i_user_id   IN     x_user_service_map.x_usm_user_id%TYPE,
      o_cursor       OUT pkg_common.cursor_data)
   AS
   BEGIN
      OPEN o_cursor FOR
         SELECT s1.ms_media_service_code,
                S1.MS_MEDIA_SERVICE_DESC,
                s1.ms_media_service_flag,
                s2.x_usm_user_id,
                S1.MS_IS_WAIVE_HOLDBACK
           FROM sgy_pb_media_service s1, x_user_service_map s2
          WHERE     s1.MS_MEDIA_SERVICE_CODE = s2.x_usm_media_service_code
                AND s1.ms_media_service_parent = 'CATCHUP'
                AND UPPER (x_usm_user_id) = UPPER (i_user_id);
   END prc_cp_media_ser_lk;

   --[Pravin][20150805] - Implementation of Translated Genre lookup.
   PROCEDURE PRC_LOOKUP_GET_TRANS_GENRE (
      I_LANG_ID   IN     X_TBL_MM_LANGUAGES.LANG_ID%TYPE,
      O_REF_CUR      OUT PKG_COMMON.CURSOR_DATA)
   AS
   BEGIN
      IF I_LANG_ID > 0
      THEN
         OPEN O_REF_CUR FOR
            SELECT TRG.XTG_GENRE_ID, TRG.XTG_GENRE_CODE, TRG.XTG_GENRE_DESC
              FROM    X_TRANSLATED_GENRE TRG
                   INNER JOIN
                      X_TBL_MM_LANGUAGES LAN
                   ON TRG.XTG_LANG_ID = LAN.LANG_ID
             WHERE TRG.XTG_LANG_ID = I_LANG_ID;
      ELSE
         OPEN O_REF_CUR FOR
            SELECT TRG.XTG_GENRE_ID, TRG.XTG_GENRE_CODE, TRG.XTG_GENRE_DESC
              FROM    X_TRANSLATED_GENRE TRG
                   INNER JOIN
                      X_TBL_MM_LANGUAGES LAN
                   ON TRG.XTG_LANG_ID = LAN.LANG_ID;
      END IF;
   END PRC_LOOKUP_GET_TRANS_GENRE;
   --[Pravin][20150805] - Implementation of Translated Genre lookup. - End

   PROCEDURE x_prc_cont_distr_lookup (
      i_rel_entity       IN     VARCHAR2,
      i_owner_licensee          VARCHAR2,
      o_rel_for             OUT SYS_REFCURSOR)
   AS
      l_whp_release_for   VARCHAR2 (40);
   BEGIN
      OPEN o_rel_for FOR
         SELECT DISTINCT
                DECODE (i_rel_entity,
                        'Licensee', WHP_RELEASE_TO_LEE,
                        WHP_RELEASE_TO_CHA)
                   "WHP_RELEASE_TO"
           --  into l_whp_release_for
           FROM X_TBL_WHP_CONFG
          WHERE WHP_RELEASE_ENTITY = i_rel_entity
                ----added by rashmi
                -- and WHP_OWNER_LICENSEE=i_owner_licensee
                AND WHP_OWNER_LICENSEE LIKE
                       DECODE (i_owner_licensee,
                               '%', WHP_OWNER_LICENSEE,
                               i_owner_licensee) --RDT :[BR_15_309_Content_CR]_[Rashmi_Tijare]
                                                ;
   END;

   /* procedure x_prc_edit_suit_area_search(i_user_id      IN VARCHAR2
                                         ,o_edit_suite      OUT sys_refcursor
                                         )
    as
    l_role_is_admin NUMBER;
    begin
                select COUNT(1)
        into l_role_is_admin
        from ora_aspnet_users u
            ,ora_aspnet_usersinroles ur
            ,ora_aspnet_roles r
        where u.USERID=ur.USERID
        and   r.ROLEID=ur.roleid
        and   u.username LIKE '%'||lower(i_user_id)||'%'
        AND   r.rolename='Admin'
        ;

        IF l_role_is_admin = 0 THEN
          open o_edit_suite FOR
          SELECT ES_NAME,ES_DESCRIPTION FROM X_TBL_EDIT_SUIT
            WHERE ES_AREA IN
            (SELECT ES_AREA  FROM X_TBL_EDIT_SUIT WHERE ES_ID IN
            (SELECT ESUM_ES_ID FROM X_TBL_EDIT_SUIT_USER_MAPP WHERE ESUM_USER_ID = upper(i_user_id)))
             order by ES_NAME;
        ELSE
         open o_edit_suite FOR
          SELECT ES_NAME,ES_DESCRIPTION FROM X_TBL_EDIT_SUIT
            ;
        END IF;
    end x_prc_edit_suit_area_search;*/

   PROCEDURE x_prc_edit_suit_area_ate (i_user_id      IN     VARCHAR2,
                                       o_edit_suite      OUT SYS_REFCURSOR)
   AS
      l_role_is_admin   NUMBER;
   BEGIN
      SELECT COUNT (1)
        INTO l_role_is_admin
        FROM ora_aspnet_users u,
             ora_aspnet_usersinroles ur,
             ora_aspnet_roles r
       WHERE     u.USERID = ur.USERID
             AND r.ROLEID = ur.roleid
             AND u.username LIKE '%' || LOWER (i_user_id) || '%'
             AND r.rolename = 'Admin';

      IF l_role_is_admin = 0
      THEN
         OPEN o_edit_suite FOR
              SELECT ES_NAME, ES_DESCRIPTION,ES_ID
                FROM X_TBL_EDIT_SUIT
               WHERE ES_AREA IN
                        (SELECT ES_AREA
                           FROM X_TBL_EDIT_SUIT
                          WHERE ES_ID IN
                                   (SELECT ESUM_ES_ID
                                      FROM X_TBL_EDIT_SUIT_USER_MAPP
                                       --commented condition by rupali for UserID issue for Edit Suit
                                     --WHERE ESUM_USER_ID = UPPER (i_user_id)))
                                    --Added Condition by rupali for UserID issue for Edit Suit
                                      where (UPPER(ESUM_USER_ID)=UPPER(i_user_id)
                                       or upper(ESUM_USER_ID)= (select  replace (UPPER (usr_ad_loginid), 'ZA\', '') from men_user where upper(usr_id) = upper(i_user_id)))))
            ORDER BY ES_NAME;
      ELSE
         OPEN o_edit_suite FOR
            SELECT ES_NAME, ES_DESCRIPTION,ES_ID FROM X_TBL_EDIT_SUIT;
      END IF;
   END x_prc_edit_suit_area_ate;

   PROCEDURE x_prc_edit_suit_area_uids (i_user_id      IN     VARCHAR2,
                                        o_edit_suite      OUT SYS_REFCURSOR)
   AS
      l_role_is_admin   NUMBER;
   BEGIN
      SELECT COUNT (1)
        INTO l_role_is_admin
        FROM ora_aspnet_users u,
             ora_aspnet_usersinroles ur,
             ora_aspnet_roles r
       WHERE     u.USERID = ur.USERID
             AND r.ROLEID = ur.roleid
             AND u.username LIKE '%' || LOWER (i_user_id) || '%'
             AND r.rolename = 'Admin';

      IF l_role_is_admin = 0
      THEN
         OPEN o_edit_suite FOR
              SELECT ES_NAME, ES_DESCRIPTION,ES_ID
                FROM X_TBL_EDIT_SUIT
               WHERE ES_ID IN (SELECT ESUM_ES_ID
                                 FROM X_TBL_EDIT_SUIT_USER_MAPP
								 --commented condition by rupali for UserID issue for Edit Suit
                                --WHERE ESUM_USER_ID = UPPER (i_user_id))
								--Added Condition by rupali for UserID issue for Edit Suit
								  where (UPPER(ESUM_USER_ID)=UPPER(i_user_id)
                                       or upper(ESUM_USER_ID)= (select  replace (UPPER (usr_ad_loginid), 'ZA\', '') from men_user where upper(usr_id) = upper(i_user_id))))
            ORDER BY ES_NAME;
      ELSE
         OPEN o_edit_suite FOR
            SELECT ES_NAME, ES_DESCRIPTION,ES_ID FROM X_TBL_EDIT_SUIT;
      END IF;
   END x_prc_edit_suit_area_uids;

   ---Added By Rashmi For Svod For Deal:RDT    :start
   PROCEDURE PRC_LOOKUP_LOAD_DEAL (
      i_release_for   IN     VARCHAR2,
      O_REF_CUR          OUT PKG_COMMON.CURSOR_DATA)
   AS
   BEGIN
      OPEN O_REF_CUR FOR
         SELECT DISTINCT mem_id Deal_No,
                         TRUNC (mem_date) Deal_Date,
                         con_short_name Contract_Number,
                         a.lee_short_name Main_Licensee,
                         a.com_short_name Licensor,
                         b.com_short_name Contract_Entity,
                         mem_status Status,
                         mem_currency,
                         mem_amort_method Amortization
           FROM sak_memo,
                fid_licensee a,
                fid_company a,
                fid_company b,
                fid_contract
          WHERE     mem_com_number = a.com_number
                AND mem_con_number = con_number(+)
                AND mem_agy_com_number = b.com_number(+)
                -- and    com_qa_required ='N'
                -- and     mem_status <> 'EXECUTED'
                AND mem_status IN
                       ('REGISTERED',
                        'QAPASSED',
                        DECODE (pkg_adm_cm_dealmemo.qarequired (mem_id),
                                'N', 'BUYER RECOMMENDED'))
                AND A.lee_number = MEM_lee_number
                AND mem_amort_method =
                       DECODE (a.lee_media_service_code,
                               'SVOD', 'A',
                               mem_amort_method)
                AND a.lee_media_service_code =
                       (SELECT lee_media_service_code
                          FROM fid_licensee
                         WHERE lee_short_name = i_release_for);
   END PRC_LOOKUP_LOAD_DEAL;
END PKG_COMMON;
/
