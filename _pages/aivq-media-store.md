---
layout: page
title: AIVQ Media Store
description: A private media archive utility maintained by Romulo Drumond.
permalink: /aivq-media-store/
nav: false
---

AIVQ Media Store is a personal-use application for archiving, verifying, and
restoring media in the owner's Google Drive. It is not a public file-sharing
service and does not offer public registration.

## What the app does

- Uploads media selected by the owner to a private, organized archive.
- Records file identifiers, sizes, and checksums so archived files can be
  verified and matched to their local originals.
- Downloads archived files when the owner requests a restore.
- Checks the connected account and available Drive storage.

## Google Drive access

The app requests Google's **`drive.file`** permission: access to files created
by the app or explicitly opened or shared with the app. It does not request
unrestricted access to every file in a Google Drive account. Account identity
and storage quota are also checked to prevent use of the wrong archive account.

Authorization happens through Google's sign-in and consent screen. The app does
not ask for or store the owner's Google password. Its archive operations do not
automatically make files public or create public sharing links.

These public information pages contain no archive files, credentials, or private
Drive links.

## Privacy, terms, and support

Read the [Privacy Policy](/aivq-media-store/privacy/) and
[Terms of Use](/aivq-media-store/terms/) before authorizing the app.

For support, privacy questions, or deletion requests, contact
[rbp.drumond@gmail.com](mailto:rbp.drumond@gmail.com).

Maintained by [Romulo Drumond](/).
