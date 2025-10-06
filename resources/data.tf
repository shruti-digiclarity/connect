data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "match_extension_lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem"
    ]
    resources = [
      module.connect_config_dynamodb.dynamodb_table_arn,
      "${module.connect_config_dynamodb.dynamodb_table_arn}/*"
    ]
  }
  statement {
    sid     = "AllowKMS"
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      "arn:aws:kms:${var.region}:${var.account_number}:key/*"
    ]
  }
}

data "aws_iam_policy_document" "voice_mail_packager_lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "connect:DescribeUser",
      "connect:DescribeQueue",
      "connect:GetContactAttributes",
      "connect:UpdateContactAttributes",
      "connect:StartTaskContact"
    ]
    resources = [
      module.amazon_connect.instance_arn,
      "${module.amazon_connect.instance_arn}/*",
    ]
  }
  statement {
    sid    = "AllowS3Access"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObjectTagging",
      "s3:GetObject"
    ]
    resources = [
      module.s3_voice_mail_transcript.bucket_arn,
      "${module.s3_voice_mail_transcript.bucket_arn}/*",
      module.s3_voice_mail_recording.bucket_arn,
      "${module.s3_voice_mail_recording.bucket_arn}/*"
    ]
  }
  statement {
    sid     = "AllowLambdaInvoke"
    effect  = "Allow"
    actions = ["lambda:InvokeFunction"]
    resources = [
      "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.company_prefix}-lmda-voice-mail-presigner-${local.region_prefix}-${var.env}"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem"
    ]
    resources = [
      module.connect_config_dynamodb.dynamodb_table_arn,
      "${module.connect_config_dynamodb.dynamodb_table_arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail"
    ]
    resources = [
      "arn:aws:ses:${var.region}:${data.aws_caller_identity.current.account_id}:identity/*",
      "arn:aws:ses:${var.region}:${data.aws_caller_identity.current.account_id}:configuration-set/*"
    ]
  }
  statement {
    sid     = "AllowKMS"
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      "arn:aws:kms:${var.region}:${var.account_number}:key/*"
    ]
  }
}


data "aws_iam_policy_document" "kvs_to_s3_lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesisvideo:GetDataEndpoint",
      "kinesisvideo:ListFragments",
      "kinesisvideo:GetMediaForFragmentList"
    ]
    resources = [
      "${module.kinesis.kinesis_stream_arn}",
      "arn:aws:kinesisvideo:${var.region}:${data.aws_caller_identity.current.account_id}:stream/*"
    ]
  }
  statement {
    sid    = "AllowS3Access"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectTagging"
    ]
    resources = [
      module.s3_voice_mail_recording.bucket_arn,
      "${module.s3_voice_mail_recording.bucket_arn}/*"
    ]
  }
  statement {
    sid    = "AllowKMS"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey"
    ]
    resources = [
      "arn:aws:kms:${var.region}:${var.account_number}:key/*"
    ]
  }
}


data "aws_iam_policy_document" "voice_mail_presigner_lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging"
    ]
    resources = [
      module.s3_voice_mail_recording.bucket_arn,
      "${module.s3_voice_mail_recording.bucket_arn}/*"
    ]
  }
  statement {
    sid     = "AllowKMS"
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      "arn:aws:kms:${var.region}:${var.account_number}:key/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      module.iam_user_crerdentials_secret.secret_arn[0],
      "${module.iam_user_crerdentials_secret.secret_arn[0]}/*"
    ]
  }
}


data "aws_iam_policy_document" "voice_mail_transcriber_lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]
    resources = [
      module.s3_voice_mail_transcript.bucket_arn,
      "${module.s3_voice_mail_transcript.bucket_arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging"
    ]
    resources = [
      module.s3_voice_mail_recording.bucket_arn,
      "${module.s3_voice_mail_recording.bucket_arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "transcribe:StartTranscriptionJob"
    ]
    resources = [
      "arn:aws:transcribe:${var.region}:${data.aws_caller_identity.current.account_id}:transcription-job/*"
    ]
  }
  statement {
    sid     = "AllowKMS"
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      "arn:aws:kms:${var.region}:${var.account_number}:key/*"
    ]
  }
}

data "aws_iam_policy_document" "get_connect_config_lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem"
    ]
    resources = [
      module.connect_config_dynamodb.dynamodb_table_arn,
      "${module.connect_config_dynamodb.dynamodb_table_arn}/*",
      data.aws_dynamodb_table.customer_outbound_callerid_mapping_table.arn,
      "${data.aws_dynamodb_table.customer_outbound_callerid_mapping_table.arn}/*"
    ]
  }
  statement {
    sid     = "AllowKMS"
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      "arn:aws:kms:${var.region}:${var.account_number}:key/*"
    ]
  }
}

data "aws_iam_policy_document" "check_holiday_and_hoop_lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem"
    ]
    resources = [
      module.connect_config_dynamodb.dynamodb_table_arn,
      "${module.connect_config_dynamodb.dynamodb_table_arn}/*"
    ]
  }
  statement {
    sid     = "AllowKMS"
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      "arn:aws:kms:${var.region}:${var.account_number}:key/*"
    ]
  }
}

data "aws_iam_policy_document" "load_config_data_lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchWriteItem"
    ]
    resources = [
      module.connect_config_dynamodb.dynamodb_table_arn,
      "${module.connect_config_dynamodb.dynamodb_table_arn}/*"
    ]
  }
  statement {
    sid     = "AllowKMS"
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      "arn:aws:kms:${var.region}:${var.account_number}:key/*"
    ]
  }
}

data "aws_iam_policy_document" "lead_generation_lambda_policy" {
  version = "2012-10-17"
  statement {
    sid     = "AllowSecretsManager"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      module.connect_lead_generation_secret.secret_arn[0]
    ]
  }

}

data "aws_iam_policy_document" "campaign_attribution_lambda_policy" {
  version = "2012-10-17"
  statement {
    sid     = "AllowSecretsManager"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      module.connect_campaign_attribution_secret.secret_arn[0]
    ]
  }
}

data "aws_iam_policy_document" "slack_notifier_lambda_policy" {
  version = "2012-10-17"
  statement {
    sid     = "AllowSecretsManager"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      module.connect_slack_notifier_secret.secret_arn[0]
    ]
  }
}

data "aws_dynamodb_table" "customer_outbound_callerid_mapping_table" {
  name = "${var.company_prefix}-dydb-customer-outbound-callerid-mapping-${local.region_prefix}-${var.env}"
}

data "aws_connect_quick_connect" "jilliann_perez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Jilliann Perez"
}

data "aws_connect_quick_connect" "janine_gutierrez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Janine Gutierrez"
}

data "aws_connect_quick_connect" "vanessa_osorio" {
  instance_id = module.amazon_connect.instance_id
  name        = "Vanessa Osorio"
}

data "aws_connect_quick_connect" "christina_feindt" {
  instance_id = module.amazon_connect.instance_id
  name        = "Christina Feindt"
}

data "aws_connect_quick_connect" "melissa_jevic" {
  instance_id = module.amazon_connect.instance_id
  name        = "Melissa Jevic"
}

data "aws_connect_quick_connect" "cathy_wallin" {
  instance_id = module.amazon_connect.instance_id
  name        = "Cathy Wallin"
}

data "aws_connect_quick_connect" "avital_rosenberg" {
  instance_id = module.amazon_connect.instance_id
  name        = "Avital Rosenberg"
}

data "aws_connect_quick_connect" "adria_french" {
  instance_id = module.amazon_connect.instance_id
  name        = "Adria French"
}

data "aws_connect_quick_connect" "denise_lopez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Denise Lopez"
}

data "aws_connect_quick_connect" "eileen_ball" {
  instance_id = module.amazon_connect.instance_id
  name        = "Eileen Ball"
}

data "aws_connect_quick_connect" "inessa_tsygan" {
  instance_id = module.amazon_connect.instance_id
  name        = "Inessa Tsygan"
}

data "aws_connect_quick_connect" "jacqueline_alvarez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Jacqueline Alvarez"
}

data "aws_connect_quick_connect" "janet_jones" {
  instance_id = module.amazon_connect.instance_id
  name        = "Janet Jones"
}

data "aws_connect_quick_connect" "jean_kaplan" {
  instance_id = module.amazon_connect.instance_id
  name        = "Jean Kaplan"
}

data "aws_connect_quick_connect" "jennifer_quittley" {
  instance_id = module.amazon_connect.instance_id
  name        = "Jennifer Quittley"
}

data "aws_connect_quick_connect" "jennifer_sullivan" {
  instance_id = module.amazon_connect.instance_id
  name        = "Jennifer Sullivan"
}

data "aws_connect_quick_connect" "madeline_dipietro" {
  instance_id = module.amazon_connect.instance_id
  name        = "Madeline DiPietro"
}

data "aws_connect_quick_connect" "maria_lent" {
  instance_id = module.amazon_connect.instance_id
  name        = "Maria Lent"
}

data "aws_connect_quick_connect" "maria_vallejos" {
  instance_id = module.amazon_connect.instance_id
  name        = "Maria Vallejos"
}

data "aws_connect_quick_connect" "marie_cadestin" {
  instance_id = module.amazon_connect.instance_id
  name        = "Marie Cadestin"
}

data "aws_connect_quick_connect" "mary_vuolo" {
  instance_id = module.amazon_connect.instance_id
  name        = "Mary Vuolo"
}

data "aws_connect_quick_connect" "mily_febus" {
  instance_id = module.amazon_connect.instance_id
  name        = "Mily Febus"
}

data "aws_connect_quick_connect" "molly_desarme" {
  instance_id = module.amazon_connect.instance_id
  name        = "Molly Desarme"
}

data "aws_connect_quick_connect" "nancy_nunez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Nancy Nunez"
}

data "aws_connect_quick_connect" "tara_elze" {
  instance_id = module.amazon_connect.instance_id
  name        = "Tara Elze"
}

data "aws_connect_quick_connect" "tia_thomas" {
  instance_id = module.amazon_connect.instance_id
  name        = "Tia Thomas"
}

data "aws_connect_quick_connect" "wendy_valencia" {
  instance_id = module.amazon_connect.instance_id
  name        = "Wendy Valencia"
}

data "aws_connect_quick_connect" "beatrice_gomez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Beatrice Gomez"
}

data "aws_connect_quick_connect" "sulay_inoa_guzman" {
  instance_id = module.amazon_connect.instance_id
  name        = "Sulay Inoa Guzman"
}

data "aws_connect_quick_connect" "jesenia_hernandez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Jesenia Hernandez"
}

data "aws_connect_quick_connect" "miriam_rodriguez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Miriam Rodriguez"
}

data "aws_connect_quick_connect" "ruby_gonzalez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Ruby Gonzalez"
}

data "aws_connect_quick_connect" "sarah_thomas" {
  instance_id = module.amazon_connect.instance_id
  name        = "Sarah Thomas"
}

data "aws_connect_quick_connect" "stephanie_vallejo" {
  instance_id = module.amazon_connect.instance_id
  name        = "Stephanie Vallejo"
}

data "aws_connect_quick_connect" "robert_santos_perez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Robert Santos Perez"
}

data "aws_connect_quick_connect" "catherine_garcia" {
  instance_id = module.amazon_connect.instance_id
  name        = "Catherine Garcia"
}

data "aws_connect_quick_connect" "nnenna_nwanonyiri" {
  instance_id = module.amazon_connect.instance_id
  name        = "Nnenna Nwanonyiri"
}

data "aws_connect_quick_connect" "jessica_mendoza" {
  instance_id = module.amazon_connect.instance_id
  name        = "Jessica Mendoza"
}

data "aws_connect_quick_connect" "indiana_luciano" {
  instance_id = module.amazon_connect.instance_id
  name        = "Indiana Luciano"
}

data "aws_connect_quick_connect" "damaris_lopez_cruz" {
  instance_id = module.amazon_connect.instance_id
  name        = "Damaris Lopez Cruz"
}

data "aws_connect_quick_connect" "fiorela_valdez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Fiorela Valdez"
}

data "aws_connect_quick_connect" "awilda_rios" {
  instance_id = module.amazon_connect.instance_id
  name        = "Awilda Rios"
}

data "aws_connect_quick_connect" "maria_penaherrera" {
  instance_id = module.amazon_connect.instance_id
  name        = "Maria Penaherrera"
}

data "aws_connect_quick_connect" "ana_jozamera" {
  instance_id = module.amazon_connect.instance_id
  name        = "Ana Jozamera"
}

data "aws_connect_quick_connect" "carmen_rodriguez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Carmen Rodriguez"
}

data "aws_connect_quick_connect" "linette_roman" {
  instance_id = module.amazon_connect.instance_id
  name        = "Linette Roman"
}

data "aws_connect_quick_connect" "andrea_morris" {
  instance_id = module.amazon_connect.instance_id
  name        = "Andrea Morris"
}

data "aws_connect_quick_connect" "mercy_norales" {
  instance_id = module.amazon_connect.instance_id
  name        = "Mercy Norales"
}

data "aws_connect_quick_connect" "michael_real" {
  instance_id = module.amazon_connect.instance_id
  name        = "Michael Real"
}

data "aws_connect_quick_connect" "jacqueline_garcia" {
  instance_id = module.amazon_connect.instance_id
  name        = "Jacqueline Garcia"
}

data "aws_connect_quick_connect" "claudia_gelin" {
  instance_id = module.amazon_connect.instance_id
  name        = "Claudia Gelin"
}

data "aws_connect_quick_connect" "genesis_rodriguez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Genesis Rodriguez"
}

data "aws_connect_quick_connect" "leandra_aguirrediaz" {
  instance_id = module.amazon_connect.instance_id
  name        = "Leandra Aguirrediaz"
}

data "aws_connect_quick_connect" "alejandra_marin_giraldo" {
  instance_id = module.amazon_connect.instance_id
  name        = "Alejandra Marin Giraldo"
}

data "aws_connect_quick_connect" "estefania_sanchez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Estefania Sanchez"
}

data "aws_connect_quick_connect" "daniela_sanchez_marin" {
  instance_id = module.amazon_connect.instance_id
  name        = "Daniela Sanchez Marin"
}

data "aws_connect_quick_connect" "wallys_howe" {
  instance_id = module.amazon_connect.instance_id
  name        = "Wallys Howe"
}

data "aws_connect_quick_connect" "nancy_rodriguez_navarro" {
  instance_id = module.amazon_connect.instance_id
  name        = "Nancy Rodriguez Navarro"
}

data "aws_connect_quick_connect" "roshio_quintana" {
  instance_id = module.amazon_connect.instance_id
  name        = "Roshio Quintana"
}

data "aws_connect_quick_connect" "elaine_iudici" {
  instance_id = module.amazon_connect.instance_id
  name        = "Elaine Iudici"
}

data "aws_connect_quick_connect" "yesenia_delrio" {
  instance_id = module.amazon_connect.instance_id
  name        = "Yesenia Delrio"
}

data "aws_connect_quick_connect" "johan_witton_moyano" {
  instance_id = module.amazon_connect.instance_id
  name        = "Johan Witton Moyano"
}

data "aws_connect_quick_connect" "mauricio_luna" {
  instance_id = module.amazon_connect.instance_id
  name        = "Mauricio Luna"
}

data "aws_connect_quick_connect" "ariel_reinoso" {
  instance_id = module.amazon_connect.instance_id
  name        = "Ariel Reinoso"
}

data "aws_connect_quick_connect" "soraya_bedon" {
  instance_id = module.amazon_connect.instance_id
  name        = "Soraya Bedon"
}

data "aws_connect_quick_connect" "giselle_ventura" {
  instance_id = module.amazon_connect.instance_id
  name        = "Giselle Ventura"
}

data "aws_connect_quick_connect" "giselle_tejada" {
  instance_id = module.amazon_connect.instance_id
  name        = "Giselle Tejada"
}

data "aws_connect_quick_connect" "iliana_correa" {
  instance_id = module.amazon_connect.instance_id
  name        = "Iliana Correa"
}

data "aws_connect_quick_connect" "esthefany_gomez" {
  instance_id = module.amazon_connect.instance_id
  name        = "Esthefany Gomez"
}

data "aws_connect_quick_connect" "alicia_swaby" {
  instance_id = module.amazon_connect.instance_id
  name        = "Alicia Swaby"
}

data "aws_connect_quick_connect" "rosangela_papageorgiou" {
  instance_id = module.amazon_connect.instance_id
  name        = "Rosangela Papageorgiou"
}

data "aws_connect_quick_connect" "gabriela_herrera" {
  instance_id = module.amazon_connect.instance_id
  name        = "Gabriela Herrera"
}

data "aws_connect_quick_connect" "alexandra_vargas" {
  instance_id = module.amazon_connect.instance_id
  name        = "Alexandra Vargas"
}

data "aws_connect_quick_connect" "lorena_hantsoulis" {
  instance_id = module.amazon_connect.instance_id
  name        = "Lorena Hantsoulis"
}

data "aws_connect_quick_connect" "leislanimillie_sotomayor" {
  instance_id = module.amazon_connect.instance_id
  name        = "Leislanimillie Sotomayor"
}

data "aws_connect_quick_connect" "jessica_reyes" {
  instance_id = module.amazon_connect.instance_id
  name        = "Jessica Reyes"
}

data "aws_connect_quick_connect" "barbara_garcia" {
  instance_id = module.amazon_connect.instance_id
  name        = "Barbara Garcia"
}

data "aws_connect_quick_connect" "elizabeth_sexton" {
  instance_id = module.amazon_connect.instance_id
  name        = "Elizabeth Sexton"
}

data "aws_connect_quick_connect" "elizabeth_coronado" {
  instance_id = module.amazon_connect.instance_id
  name        = "Elizabeth Coronado"
}

data "aws_connect_quick_connect" "yoly_medrano" {
  instance_id = module.amazon_connect.instance_id
  name        = "Yoly Medrano"
}

data "aws_connect_quick_connect" "reynaldo_rivera" {
  instance_id = module.amazon_connect.instance_id
  name        = "Reynaldo Rivera"
}

data "aws_connect_quick_connect" "shyra_maldonado" {
  instance_id = module.amazon_connect.instance_id
  name        = "Shyra Maldonado"
}

data "aws_connect_quick_connect" "erica_alejandro" {
  instance_id = module.amazon_connect.instance_id
  name        = "Erica Alejandro"
}

data "aws_connect_quick_connect" "carisa_bautista" {
  instance_id = module.amazon_connect.instance_id
  name        = "Carisa Bautista"
}

data "aws_connect_quick_connect" "jahaira_allende" {
  instance_id = module.amazon_connect.instance_id
  name        = "Jahaira Allende"
}

data "aws_connect_quick_connect" "susan_hall" {
  instance_id = module.amazon_connect.instance_id
  name        = "Susan Hall"
}

data "aws_connect_quick_connect" "nora_torres" {
  instance_id = module.amazon_connect.instance_id
  name        = "Nora Torres"
}

data "aws_connect_quick_connect" "samantha_cordero" {
  instance_id = module.amazon_connect.instance_id
  name        = "Samantha Cordero"
}

data "aws_connect_quick_connect" "ch_ihc_admin_coordinators_en" {
  instance_id = module.amazon_connect.instance_id
  name        = "ch_ihc_admin_coordinators_en"
}

data "aws_connect_quick_connect" "ch_ihc_admin_coordinators_sp" {
  instance_id = module.amazon_connect.instance_id
  name        = "ch_ihc_admin_coordinators_sp"
}

data "aws_connect_quick_connect" "ch_ihc_pcc_en" {
  instance_id = module.amazon_connect.instance_id
  name        = "ch_ihc_pcc_en"
}

data "aws_connect_quick_connect" "ch_ihc_pcc_sp" {
  instance_id = module.amazon_connect.instance_id
  name        = "ch_ihc_pcc_sp"
}

data "aws_connect_quick_connect" "ch_ihc_enrollment_welcome_team_sp" {
  instance_id = module.amazon_connect.instance_id
  name        = "ch_ihc_enrollment_welcome_team_sp"
}

data "aws_connect_quick_connect" "ch_ihc_enrollment_welcome_team_en" {
  instance_id = module.amazon_connect.instance_id
  name        = "ch_ihc_enrollment_welcome_team_en"
}

data "aws_connect_quick_connect" "ch_clinical_care_management_en" {
  instance_id = module.amazon_connect.instance_id
  name        = "ch_clinical_care_management_en"
}

data "aws_connect_quick_connect" "ch_clinical_care_management_sp" {
  instance_id = module.amazon_connect.instance_id
  name        = "ch_clinical_care_management_sp"
}

# data "aws_connect_quick_connect" "ch_ccv_ga_scheduling_en"{
#   instance_id = module.amazon_connect.instance_id
#   name        = "ch_ccv_ga_scheduling_en"
# }

# data "aws_connect_quick_connect" "ch_ccv_ga_scheduling_sp"{
#   instance_id = module.amazon_connect.instance_id
#   name        = "ch_ccv_ga_scheduling_sp"
# }

# data "aws_connect_quick_connect" "ch_ccv_scheduling_en" {
#   instance_id = module.amazon_connect.instance_id
#   name        = "ch_ccv_scheduling_en"
# }

# data "aws_connect_quick_connect" "ch_ccv_scheduling_sp" {
#   instance_id = module.amazon_connect.instance_id
#   name        = "ch_ccv_scheduling_sp"
# }

# data "aws_connect_quick_connect" "ch_ccv_whv_scheduling_en"{
#   instance_id = module.amazon_connect.instance_id
#   name        = "ch_ccv_whv_scheduling_en"
# }

# data "aws_connect_quick_connect" "ch_ccv_whv_scheduling_sp"{
#   instance_id = module.amazon_connect.instance_id
#   name        = "ch_ccv_whv_scheduling_sp"
# }