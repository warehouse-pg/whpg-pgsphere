--
-- Check that CREATE EXTENSION left the same pg_operator rows for pg_sphere
-- on the coordinator and on every segment.  Catalog changes made by plain
-- DML in the extension script are not dispatched and would show up here.
--

-- Sanity: one row per node (coordinator + every primary segment), so the
-- mismatch check below cannot pass vacuously.
SELECT count(*) = (SELECT count(*) + 1 FROM gp_segment_configuration
                   WHERE role = 'p' AND content >= 0) AS all_nodes
FROM (SELECT oid FROM pg_operator
      WHERE oid = '=(spoint, spoint)'::regoperator
      UNION ALL
      SELECT oid FROM gp_dist_random('pg_operator')
      WHERE oid = '=(spoint, spoint)'::regoperator) q;

SELECT oprcanhash FROM pg_operator
WHERE oid = '=(spoint, spoint)'::regoperator;

-- Every pg_sphere operator must exist on every segment with the same row.
WITH ext_ops AS (
   SELECT qd.*
   FROM pg_operator qd
        JOIN pg_depend d ON d.classid = 'pg_operator'::regclass
                        AND d.objid = qd.oid
                        AND d.refclassid = 'pg_extension'::regclass
        JOIN pg_extension e ON e.oid = d.refobjid AND e.extname = 'pg_sphere'
)
SELECT 'mismatch on seg ' || s.content || ': ' ||
       qd.oid::regoperator AS problem
FROM ext_ops qd
     CROSS JOIN gp_segment_configuration s
     LEFT JOIN gp_dist_random('pg_operator') seg
            ON seg.oid = qd.oid AND seg.gp_segment_id = s.content
WHERE s.role = 'p' AND s.content >= 0
  AND row(qd.*)::text IS DISTINCT FROM row(seg.*)::text
ORDER BY 1;
