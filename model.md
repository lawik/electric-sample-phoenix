Page, pages

- slug, string (PK)
- title, string
- summary, string
- collection, ref Collection (collection_slug) (nullable, FK)

Collection, collections

- slug, string (PK)
- name, string

ContentText

- id, uuid
- page, ref Page (page_slug) (not null, FK)
- text
- weight

..later ContentImage