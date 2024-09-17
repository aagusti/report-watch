SELECT a.tahun, a.bulan, '11' prov, '20' kab, :jenisdt jenis, left(b.kd_export,1) as gol_kd, c.uraian gol_nm
       ,count(*) jml,sum(jml_si) jml_si, sum(jml_anak) jml_anak, sum(gaji_pokok) gapok, sum(tunj_istri) t_istri
       , sum(tunj_anak) t_anak,sum(tunj_penghasilan) perbaikan, sum(tunj_jab_struktur) tunj_struk
       , sum(tunj_jab_fungsi) tunj_fungsi, 0 jab_khusus, sum(tunj_umum+tunj_umum_tamb) umum
       , sum(tunj_otsus) kemahalan, sum(tunj_dt) tunj_dt, sum(tunj_askes) tunj_askes, sum(pph) tunj_pajak
       , sum(pembulatan) tunj_pembulatan, sum(tunj_beras) tunj_beras
       , sum(gaji_pokok+tunj_istri+tunj_anak+tunj_penghasilan+tunj_jab_struktur+tunj_jab_fungsi+0+
             tunj_umum+tunj_umum_tamb+tunj_otsus+tunj_dt+tunj_askes+pph+pembulatan+tunj_beras) kotor
       , sum(POT_IWP) iwp, sum(tunj_askes) askes,sum(POT_PANGAN) bulog, sum(POT_TAPERUM) taperum 
       , sum(pph) pajak, sum(POT_SEWA_RUMAH) sewa, sum(POT_HUTANG+POT_GAJI_LEBIH+POT_KORPRI) hutang
       , sum(POT_IWP+tunj_askes+POT_PANGAN+POT_TAPERUM+pph+POT_SEWA_RUMAH+POT_HUTANG+POT_GAJI_LEBIH+POT_KORPRI) potongan
       , sum(gaji_pokok+tunj_istri+tunj_anak+tunj_penghasilan+tunj_jab_struktur+tunj_jab_fungsi+0+
             tunj_umum+tunj_umum_tamb+tunj_otsus+tunj_dt+tunj_askes+pph+pembulatan+tunj_beras) -
         sum(POT_IWP+tunj_askes+POT_PANGAN+POT_TAPERUM+pph+POT_SEWA_RUMAH+POT_HUTANG+POT_GAJI_LEBIH+POT_KORPRI) bersih
FROM PEGAWAI_GAJI a
LEFT JOIN tblgolongan b on a.golongankd = b.golongankd
LEFT JOIN tblgolongan c ON left(b.kd_export,1)=c.kd_export
WHERE TAHUN=:tahun
      AND BULAN=:bulan
      AND JENIS=:jenis
GROUP BY  a.tahun, a.bulan, jenis, left(b.kd_export,1), c.uraian