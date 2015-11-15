if Rails.env.production?
Paperclip::Attachment.default_options.merge!(
  url: ':s3_domain_url',
  storage: :s3,
  path: '/:class.:rails_env/:style/:id.:attachment.:filename',
    # The files url will be something like
    # /job.development/thumb/23.curriculum.John.png 
    #
    # path: '/:class/:attachment/:id_partition/:style/:filename',
    # class:          jobs # For the class Job
    # attachment:     image
    #                 Returns the pluralized form of the attachment name. e.g.
    #                 "avatars" for an attachment of has_attached_file(:avatar)
    # id_partition:   1
    # rails_env       production
    # style:          mini
    # filename:       something for something.jpg
    # Check all names in:
    # https://github.com/thoughtbot/paperclip/blob/master/lib/paperclip/interpolations.rb
    #
    # NOTE: You can override these with path attribute in has_attached_file
  s3_credentials: {
    bucket:            Rails.application.secrets.s3_bucket,
    access_key_id:     Rails.application.secrets.aws_access_key_id,
    secret_access_key: Rails.application.secrets.aws_secret_access_key },
    # Use keys from secrets.yml
  convert_options: {
    all: "-strip -interlace Plane -sampling-factor 4:2:0 -quality 85%" }
    # Convert options in images by default
    # Progressive scan, quality 85% by default, remove exif data
)
end
