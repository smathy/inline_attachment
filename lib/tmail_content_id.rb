module TMail

  class HeaderField   # redefine
  
      FNAME_TO_CLASS = {
        'date'                      => DateTimeHeader,
        'resent-date'               => DateTimeHeader,
        'to'                        => AddressHeader,
        'cc'                        => AddressHeader,
        'bcc'                       => AddressHeader,
        'from'                      => AddressHeader,
        'reply-to'                  => AddressHeader,
        'resent-to'                 => AddressHeader,
        'resent-cc'                 => AddressHeader,
        'resent-bcc'                => AddressHeader,
        'resent-from'               => AddressHeader,
        'resent-reply-to'           => AddressHeader,
        'sender'                    => SingleAddressHeader,
        'resent-sender'             => SingleAddressHeader,
        'return-path'               => ReturnPathHeader,
        'message-id'                => MessageIdHeader,
        'resent-message-id'         => MessageIdHeader,
        'in-reply-to'               => ReferencesHeader,
        'received'                  => ReceivedHeader,
        'references'                => ReferencesHeader,
        'keywords'                  => KeywordsHeader,
        'encrypted'                 => EncryptedHeader,
        'mime-version'              => MimeVersionHeader,
        'content-type'              => ContentTypeHeader,
        'content-transfer-encoding' => ContentTransferEncodingHeader,
        'content-disposition'       => ContentDispositionHeader,
       # 'content-id'                => MessageIdHeader,
        'subject'                   => UnstructuredHeader,
        'comments'                  => UnstructuredHeader,
        'content-description'       => UnstructuredHeader
      }
  
  end

end