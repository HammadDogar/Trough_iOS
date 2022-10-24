//
//  BlobUploadManager.swift
//  ContestantCenter
//
//  Created by Hassan Ilyas on 6/13/22.
//

import UIKit
import AZSClient

public class BlobUploadManager: NSObject {
    
    fileprivate let AZURE_ACCOUNT_NAME = "troughblobstorage"
    fileprivate let AZURE_ACCOUNT_KEY = "wORita5buqIuzgNOVOBauGvZ0CbE04gaZKhmPsZJ13c25I7miTSKFdaWSSFLSCStSUfck6Gm4q/X+ASt0QosxQ=="
    fileprivate let AZURE_STORAGE_CONTAINER = "troughprodcontainer"
    fileprivate let AZURE_BASE_URL = "https://troughblobstorage.blob.core.windows.net"
    
    var imagesBaseUrl: String {
        return AZURE_BASE_URL + "/" + AZURE_STORAGE_CONTAINER
    }
    
    static let shared = BlobUploadManager()
    
    private override init() {
        super.init()
    }
    
    func uploadFile(fileData: Data, fileName: String, folder: String, completion: @escaping (_ filePath: String, _ completed: Bool) -> Void) {
        let folderName = generateContainer(type: folder)
        self.generateURLForBlob(folderName: folderName, fileName: fileName) { (completed, blob, blobUrl) in
            if completed {
                self.uploadFile(data: fileData, blob: blob!) { (success) in
                    if success {
                        completion(blobUrl ?? "", success)
                    }else {
                        completion("", success)
                    }
                }
            }else {
                completion("", false)
            }
        }
    }
    
    private func generateContainer(type: String) -> String{
        return "\(type)"
    }
    
    /**
     * Generate a new blob for a file
     * Requires a file extension
     */
    private func generateURLForBlob (folderName: String, fileName: String, completion: @escaping (_ success: Bool, _ blob: AZSCloudBlockBlob?, _ blobURL: String?) -> Void)   {
        
        if let account = try? AZSCloudStorageAccount(fromConnectionString: "DefaultEndpointsProtocol=https;AccountName=\(AZURE_ACCOUNT_NAME);AccountKey=\(AZURE_ACCOUNT_KEY);EndpointSuffix=core.windows.net") {
            let client = account.getBlobClient()
            let container = client.containerReference(fromName: AZURE_STORAGE_CONTAINER)
            container.createContainerIfNotExists(with: .container, requestOptions: nil, operationContext: nil, completionHandler: { (error, exists) in
                if error != nil {
                    print(error.debugDescription)
                    print("error creating container")
                    completion(false, nil, nil)
                } else {
                    let directory = container.directoryReference(fromName: folderName)
                    let blobURL = "/\(folderName)/\(fileName)"
                    let blob = directory.blockBlobReference(fromName: fileName)
                    completion(true, blob, blobURL)
                }
            })
        }
    }
        
    private func uploadFile(data: Data, blob: AZSCloudBlockBlob,completion: @escaping (_ success: Bool) -> Void) {
        blob.upload(from: data) { (error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
}
