[Database Relationship Diagrams]: https://dbdiagram.io/d/61ef4adb7cf3fc0e7c601287

[Database Relationship Diagrams](https://dbdiagram.io/d/61ef4adb7cf3fc0e7c601287 )

**Password**: MUSA801

(Red tables are main data resource, and yellow tables are significant intermediary data.)





1. **DataFrame / Table names**: 

   Table names are consistent with df names within 'PPPR.rmd' from Shaun.

   

2. **Indexes**: 

   Fields (columns) in bold font represent indexes (unique ID). Indexes information can also be displayed by hovering mouse around table header. 

3. **Multi-column Indexes**:

   When several fields are marked as the index together, it means that none of them is able to be unique index, instead the combination of them is the actual index.

   

4. **Fields**: 

   Fields with many NAs and unconstructive fields are not listed.

   

5. **Join Connections**: 

   Lines only clasified how indivisual cases can join with each other. Aggregating relations are not enumerated. (Eg, program2021.ActvityTypeCategory <-> recreation2021.Category)

6. **Particula Join Connections**: 

   For table "recreation2021", there's no perfectly aligned key. Although it is marked that <u>recreation2021.Address varchar  <->  pprProperties.ADDRESS_911</u>, these two adress systems are slightly different, and cannot be joined directly. It's the same case for <u>program2021.Facility varchar  <->  pprProperties.PUBLIC_NAME</u>.