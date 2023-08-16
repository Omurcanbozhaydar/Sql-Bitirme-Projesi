CREATE EXTENSION IF NOT EXISTS aws_s3 CASCADE; ##Bu komut aws_s3 extension i yaratmak icin kullanilir.

2-) SELECT aws_s3.table_import_from_s3(
  'market_sales_master', '', '(FORMAT CSV, HEADER true)', 
  'sqlprojem', 'test_market_utf_full.csv', 'eu-west-3');
 


 insert into branch (branchnr,branch,city,region,latitude,longitude)
 select distinct branchnr,branch,city,region,latitude,longitude
 from market_sales_master 
 where branchnr is not null
 and branch is not null
 and city is not null
 and region is not null
 and latitude is not null
 and longitude is not null
 and branchnr not in (select branchnr from branch)
 
 
 insert into item (itemcode,itemname,category_name1,category_name2,category_name3)
 select distinct itemcode,itemname,category_name1,category_name2,category_name3
 from market_sales_master 
 where itemcode is not null
 and itemname is not null
 and category_name1 is not null
 and category_name2 is not null
 and category_name3 is not null
 and itemcode not in (select itemcode from item)
 
 
 
 insert into sales  (id,itemcode,fichno,amount,price,linenettotal,linenet,branchnr,salesman,clientcode,brandcode,startdate,enddate)
 select distinct id,itemcode,fichno,amount,price,linenettotal,linenet,branchnr,salesman,clientcode,brandcode,startdate,enddate
 from market_sales_master 
 where id is not null
 and itemcode is not null
 and fichno is not null
 and amount is not null
 and price is not null
 and linenettotal is not null
 and linenet is not null
 and branchnr is not null
 and salesman is not null
 and clientcode is not null
 and brandcode is not null
 and startdate is not null
 and enddate is not null
 and id not in (select id from sales)
 
 insert into client (clientcode,clientname,gender)
 select distinct clientcode,clientname,gender
 from market_sales_master 
 where clientcode is not null 
 and clientname is not null 
 and gender is not null 
 and clientcode not in (select clientcode from client)
 
 insert into brand  (brandcode, brand)
 select distinct brandcode, brand
 from market_sales_master 
 where brandcode is not null 
 and brand is not null 
 and brandcode not in (select brandcode from brand)
 
 create index idx_id_yeni on sales (id);
 create index itx_itemcode_yeni on sales (itemcode);
 create index sax_salesman_yeni on sales (salesman);



--a) 
 create or replace view total_sales_region as
 select msm.region ,sum(linenettotal) as total_sales from market_sales_master msm    
 join branch b on b.branchnr = msm.branchnr 
 group by msm.region
 
  
--b)
 create or replace view en_cok_satilan_urunler as
 select itemname, sum(s.amount) as satilan_urunler  from market_sales_master msm 
 join sales s on s.id = msm.id
 group by itemname
 order by satilan_urunler desc 

 
 --c) 
 create or replace view satis_temsilcisi_performansi as
 select msm.salesman , region, sum(s.linenettotal) as toplam_satis from market_sales_master msm
 join sales s on s.id = msm.id
 group by msm.salesman,region
 order by toplam_satis desc
 
 
 
 
--9 
--b) 
create view en_cok_satan_marka as
select category_name1 , count(s.brandcode) as a  from market_sales_master msm 
join sales s on s.id = msm.id
group by category_name1  
order by a desc

create view en_cok_satan_kategori as
select b.brand,count(linenet) as a from market_sales_master msm 
join brand b on b.brandcode =msm.brandcode 
group by b.brand 
order by a desc



select * from market_sales_master msm 

