-- Attempting to match VPC records to MyC & push these cell phones.


-- First: create table of all VPC records assigned to OT2020
-- using select statement:

select * from cvi_vbm_app_chase.michigan_200611

where partner_prime_chase = 'OT2020';

-- New table: michigan.cvi_vbm_app_chase_ot2020 
-- 29432 records, each has distinct statefileid field

------------------------------------------------------------------

-- Then join to analytics_mi.person to get VAN IDs
-- Join via vb_voterid (re: Kate's email)
-- Use select statement to create a new table

select * from michigan.cvi_vbm_app_chase_ot2020 as t1

inner join analytics_mi.person as t2
on t1.statefileid = t2.vb_voterid

-- New table: michigan.cvi_vbm_app_chase_ot2020_personjoin
-- 29143 records, each has distinct statefileid / vb_voterid field

------------------------------------------------------------------
-------------------- NOW THE TROUBLE STARTS!! --------------------
------------------------------------------------------------------

-- Join to ot2020_vansync.tsm_csi_contactscontacts_vf
-- Use select statement to create new table

select * from michigan.cvi_vbm_app_chase_ot2020_personjoin as t1

inner join ot2020_vansync.tsm_csi_contactscontacts_vf as t2
on t1.vb_smartvan_id = t2.vanid

-- New table: michigan.cvi_vbm_app_chase_ot2020_myvjoin
-- 26906 records, but only 7058 unique statefileid's

-- NOTE: Also tried joining directly to ref.activity_regions but that was even worse!
-- Joined on analytics_mi.person.vb_smartvan_id and ref.activity_regions.myv_vanid
-- 2168 records, 2050 unique statefileid's

------------------------------------------------------------------

-- Then tried to join to ref.activity_regions to get MyC VAN IDs
-- Used select statement to create new table

select * from michigan.cvi_vbm_app_chase_ot2020_myvjoin as t1

inner join ot2020_vansync.tsm_csi_contacts_myc as t2
on t1.vanid = t2.myv_vanid

-- New table: michigan.cvi_vbm_app_chase_ot2020_actregjoin
-- 5436 records, 1076 unique statefileid's and 1003 unique vanid's

------------------------------------------------------------------

-- Then tried to join to ref.activity_regions to get MyC VAN IDs
-- Used select statement to create new table

select * from michigan.cvi_vbm_app_chase_ot2020_myvjoin as t1

inner join ot2020_vansync.tsm_csi_contacts_myc as t2
on t1.vanid = t2.myv_vanid

-- New table: michigan.cvi_vbm_app_chase_ot2020_actregjoin
-- 5436 records, 1076 unique statefileid's and 1003 unique vanid's

------------------------------------------------------------------
-- Felt weird about the many : many join that seemed to be happening
-- Started point checking records
-- And the names in the VPC table don't match the names in the VAN tables
-- The problem seems to be coming from joining to VAN using analytics_mi.person's vb_smartvan_id field
