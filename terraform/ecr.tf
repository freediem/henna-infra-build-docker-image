locals {
  base_imagelist = fileset("${path.module}/../images/base", "*/Dockerfile")
  gitlab_imagelist = fileset("${path.module}/../images/gitlab", "*/Dockerfile")
  k8s_imagelist = fileset("${path.module}/../images/k8s", "*/Dockerfile")
}

output "test" {
    value = local.gitlab_imagelist.*
}

# resource "aws_ecr_repository" "ecr_base_image" {
#   for_each = local.base_imagelist
  
#   name                 = join("base/",["", dirname(each.value)])
#   image_tag_mutability = "IMMUTABLE"

#   encryption_configuration {
#     encryption_type = "KMS"
#     kms_key = "arn:aws:kms:ap-northeast-2:068254914844:key/3d1ad921-0624-4006-8ad1-860cedcf739c"
#   }

#   tags = {
#     Name = "${var.service_name}-ecr-${var.aws_shot_region}-${var.environment}-gitlab-${each.value}"
#   }
# }

# resource "aws_ecr_repository" "ecr_gitlab_image" {
#   for_each = local.gitlab_imagelist
  
#   name                 = join("gitlab/",["", dirname(each.value)])
#   image_tag_mutability = "IMMUTABLE"

#   encryption_configuration {
#     encryption_type = "KMS"
#     kms_key = "arn:aws:kms:ap-northeast-2:068254914844:key/3d1ad921-0624-4006-8ad1-860cedcf739c"
#   }

#   tags = {
#     Name = "${var.service_name}-ecr-${var.aws_shot_region}-${var.environment}-gitlab-${each.value}"
#   }
# }

resource "aws_ecr_repository" "ecr_k8s_image" {
  for_each = local.k8s_imagelist
  
  name                 = join("k8s/",["", dirname(each.value)])
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key = "arn:aws:kms:ap-northeast-2:068254914844:key/3d1ad921-0624-4006-8ad1-860cedcf739c"
  }

  tags = {
    Name = "${var.service_name}-ecr-${var.aws_shot_region}-${var.environment}-k8s-${each.value}"
  }
}

data "aws_iam_policy_document" "push_and_pull" {
  statement {
    sid    = "ElasticContainerRegistryPushAndPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::064699816182:root",
        "arn:aws:iam::855469239994:root",
        "arn:aws:iam::514738259429:root"
      ]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
  }
}

resource "aws_ecr_repository_policy" "ecr_policy_app_dev" {
  for_each = local.k8s_imagelist
  
  repository = aws_ecr_repository.ecr_k8s_image[each.key].name
  policy     = data.aws_iam_policy_document.push_and_pull.json
}
