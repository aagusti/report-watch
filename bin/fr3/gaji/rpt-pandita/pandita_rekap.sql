SELECT a.tahun, a.bulan, '11' prov, '20' kab, :jenisdt jenis, a.unitkd, d.unitnm, a.nip, a.nama, a.npwp
       , isnull(a.sts_pegawai_kd,'00') sts_pegawai_kd,   isnull(k.uraian,'UNKNOWN') sts_pegawai_nm
       , case when a.jns_kelamin='L' then '1' else '2' end as jns_kelamin, convert(varchar, a.tgl_lahir, 105) tgl_lahir
       , b.kd_export golongan_kd, b.uraian golongan_nm
       , isnull(e.kd_export,'00') jbt_strukturkd,  isnull(e.struktur,'NON ESELON') strukturnm
       , isnull(h.kode,'00' )           kelfungsikd,     isnull(h.uraian,'NON JABATAN') as kelfungsinm
       , isnull(g.jbt_fungsikd,'00000') fungsikd,        isnull(g.jbt_fungsi,'NON FUNGSIONAL') as fungsinm
       , isnull(a.jbt_khusus_kd,'00')   jbt_khusus_kd,    isnull(l.uraian,'NON TUNJANGAN KHUSUS') jbt_khusus_nm
       , isnull(a.guru_kd,'00')               guru_kd,        isnull(i.uraian,'NON GURU') gurunm
       , isnull(a.sertifikasi_kd,'00')   sertifikasi_kd, isnull(j.uraian,'NON SERTIFIKASI') sertifikasi_nm 
       , a.jml_si jml_si, a.jml_anak jml_anak
       , a.gaji_pokok gapok, 0 persen_gaji, a.tunj_istri t_istri, a.tunj_anak t_anak
       , a.tunj_penghasilan perbaikan, a.tunj_jab_struktur tunj_struk, a.tunj_jab_fungsi tunj_fungsi
       , 0 jab_khusus, a.tunj_umum+a.tunj_umum_tamb t_umum, a.tunj_otsus kemahalan, a.tunj_dt tunj_dt 
       , a.tunj_askes tunj_askes, a.pph tunj_pajak, a.pembulatan tunj_pembulatan, a.tunj_beras tunj_beras
       , (a.gaji_pokok+a.tunj_istri+a.tunj_anak+a.tunj_penghasilan+a.tunj_jab_struktur+a.tunj_jab_fungsi+0+
             a.tunj_umum+a.tunj_umum_tamb+a.tunj_otsus+a.tunj_dt+a.tunj_askes+a.pph+a.pembulatan+a.tunj_beras) kotor
       , a.POT_IWP iwp, a.tunj_askes askes, a.POT_PANGAN bulog, a.POT_TAPERUM taperum 
       , a.pph pajak, a.POT_SEWA_RUMAH sewa, a.POT_HUTANG+a.POT_GAJI_LEBIH+a.POT_KORPRI hutang
       , (a.POT_IWP+a.tunj_askes+a.POT_PANGAN+a.POT_TAPERUM+a.pph+a.POT_SEWA_RUMAH+a.POT_HUTANG+a.POT_GAJI_LEBIH+a.POT_KORPRI) potongan
       , (a.gaji_pokok+a.tunj_istri+a.tunj_anak+a.tunj_penghasilan+a.tunj_jab_struktur+a.tunj_jab_fungsi+0+
             a.tunj_umum+a.tunj_umum_tamb+a.tunj_otsus+a.tunj_dt+a.tunj_askes+a.pph+a.pembulatan+a.tunj_beras) -
          (a.POT_IWP+a.tunj_askes+a.POT_PANGAN+a.POT_TAPERUM+a.pph+a.POT_SEWA_RUMAH+a.POT_HUTANG+a.POT_GAJI_LEBIH+a.POT_KORPRI) bersih
FROM PEGAWAI_GAJI a
LEFT JOIN tblgolongan b on a.golongankd = b.golongankd
LEFT JOIN tblgolongan c ON left(b.kd_export,1)=c.kd_export
LEFT JOIN tblunit d ON a.unitkd=d.unitkd
LEFT JOIN tblJBT_STRUKTUR e ON a.JBT_STRUKTURKD=e.jbt_strukturkd
left join tblJBT_FUNGSI f on a.JBT_FUNGSIKD=f.jbt_fungsikd
left join tblJBT_FUNGSI g on f.kd_export=g.JBT_FUNGSIKD
left join tblfungsional_kelompok h on g.kd_kel=h.kode
LEFT JOIN tblgurus i ON a.guru_kd=i.kode
LEFT JOIN tblsertifikasi j ON a.sertifikasi_kd = j.kode
LEFT JOIN tblstspegawai k ON a.sts_pegawai_kd = k.kode
LEFT JOIN tbljbt_khusus l ON a.jbt_khusus_kd = l.kode
WHERE a.TAHUN=:tahun
      AND a.BULAN=:bulan
      AND a.JENIS=:jenis