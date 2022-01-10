/**

  An experimentation for causality analysis requires a :
  1. hypothesis
  2. success metric
  3. user grouping mechanism
 */

-- Given an experiment cohort with two variants.
-- and its results, for each variant or cohort/group we need to get the:
-- # of users who on trial to # of users who were successful in that trial
-- This can be applied in a Chi-Squared test with a 95% confidence level to
-- determine successful group or statistical significance of the results.
SELECT ef.group
     , COUNT(ef.user_id)                     as total_users_on_trial
     , COUNT(ua.user_id)                     as success
     , COUNT(ua.user_id) / COUNT(ef.user_id) as success_rate

FROM expertiment_def ef
         LEFT JOIN user_actions ua ON
            ef.user_id = ua.user_id
        AND ua.action = 'done'
WHERE ef.experiment_name = 'exp1'
GROUP BY 1;
