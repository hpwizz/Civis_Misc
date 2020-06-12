-- Code to apply Out of State supporter AC tag to MyC in VAN
-- NOT RUN in this script -> copy-pasted into Export Script as a select statement

select t1.vanid as van_id,
       4702285 as activist_code_id, -- from ot2020_vansync.tsm_csi_activistcodes (4702285 = Out of State Supporter)
       'Apply' as action,
       4 as input_type_id, -- from ot2020_vansync.tsm_csi_inputtypes (4 = Bulk)
       78 as contact_type_id, --from ot2020_vansync.tsm_csi_contacttypes (78 = No Actual Contact)
       t1.vanid as civis_external_id

from ot2020_vansync.tsm_csi_contacts_myc as t1

-- tag should be applied to Michigan records (i.e. volunteers)
where t1.statecode = 'MI'
-- that do not have Michigan addresses (either state or zip that don't match MI)
and ((t1.state <> 'MI' and t1.state is not null)
     or 
     (t1.zip5 not in (select t2.zip from michigan.mi_focode_by_zip as t2) 
      and t1.zip5 is not null)
    )

-- only add tag to non-duplicate VAN IDs
-- STOPPED RUNNING 
-- No real need to avoid duplicates and was causing response table count <> select statement from MyC
-- and t1.vanid not in (select t3.dupvanid from ot2020_vansync.tsm_csi_contactsdeduped as t3)

-- only add tag to VAN IDs that haven't already been tagged
-- NOTE: Didn't run the last line initially, inorder to create response table
and t1.vanid not in (select t4.civis_external_id from michigan.response_ac_oos_export as t4) 
