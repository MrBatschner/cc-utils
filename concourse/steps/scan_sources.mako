<%def
  name="scan_sources_step(job_step, job_variant, cfg_set, indent)",
  filter="indent_func(indent),trim"
>
<%
from makoutil import indent_func
from concourse.steps import step_lib
main_repo = job_variant.main_repository()
repo_name = main_repo.logical_name().upper()

source_scan_trait = job_variant.trait('scan_sources')
checkmarx_cfg = source_scan_trait.checkmarx()
whitesource_cfg = source_scan_trait.whitesource()
email_recipients = source_scan_trait.email_recipients()
component_trait = job_variant.trait('component_descriptor')

%>
${step_lib('component_descriptor_util')}
${step_lib('scan_sources')}

% if checkmarx_cfg:
scan_sources_and_notify(
    checkmarx_cfg_name='${checkmarx_cfg.checkmarx_cfg_name()}',
    team_id='${checkmarx_cfg.team_id()}',
    component_descriptor=component_descriptor_path(),
    email_recipients=${email_recipients},
    threshold=${checkmarx_cfg.severity_threshold()},
)
% endif

% if whitesource_cfg:
scan_component_with_whitesource(
    whitesource_cfg_name='${whitesource_cfg.cfg_name()}',
    product_token='${whitesource_cfg.product_token()}',
    component_descriptor_path=component_descriptor_path(),
    extra_whitesource_config={},
    requester_mail='${email_recipients[0]}',
)
% endif

</%def>
