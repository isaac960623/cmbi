function c3VisualAss()

addpath NIFTI_20110921



full_vol = load_nii('../data/4DCT_ref_lungs.nii');
%for m=1:3
  
  Dpred = load('c3CrossValidD3.mat');
  Dpred = Dpred.Dpred3;
  [COUCH, CPG, X, Y, Z, T, D] = size(Dpred);
  
  [COUCH, X,Y,Z,T,D]
  
  couch = 1; cpg = 8;
  reg_filename = sprintf('../data/%dpos_data_couch/reg_couch_pos%d_cine%.2d_cpg.nii',couch,couch,cpg);
  reg_cp = load_nii(reg_filename);
  
  cine_ct_filename = sprintf('../data/%dpos_data_couch/ct_couch_pos%d_cine%.2d.nii',couch,couch,cpg);
  cine_ct = load_nii(cine_ct_filename);
  
  
  trans_nii = reg_cp;
  trans_nii.img = reshape(Dpred(couch, cpg,:,:,:,:,:), [ X, Y, Z, T, D]);
  
  [def_vol_nii, def_field_nii, dis_field_nii] = deformNiiWithCPG(trans_nii,full_vol,full_vol);

  dispNiiSliceColourOverlay(cine_ct, def_vol_nii, 'z', 70);
  
  clear Dpred
%end

end