import Foundation

public class WAVFile {
    public private(set) var samples: [Float] = []
    public private(set) var sampleRate: UInt32 = 0

    public init?(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let riffStr = data.subdata(in: 0..<4)
            let waveStr = data.subdata(in: 8..<12)
            
            guard String(data: riffStr, encoding: .ascii) == "RIFF", String(data: waveStr, encoding: .ascii) == "WAVE" else {
                print("Invalid WAV file format.")
                return nil
            }
            
            var subchunkID = ""
            var subchunkSize: UInt32 = 0
            var offset = 12
            
            while offset < data.count {
                let subchunkIDData = data.subdata(in: offset..<offset + 4)
                subchunkID = String(data: subchunkIDData, encoding: .ascii) ?? ""
                subchunkSize = data.subdata(in: offset + 4..<offset + 8).withUnsafeBytes { $0.load(as: UInt32.self) }.littleEndian
                
                if subchunkID == "fmt " {
                    let audioFormat = data.subdata(in: offset + 8..<offset + 10).withUnsafeBytes { $0.load(as: UInt16.self) }.littleEndian
                    guard audioFormat == 1 else {
                        print("Unsupported audio format: \(audioFormat)")
                        return nil
                    }
                    
                    let numChannels = data.subdata(in: offset + 10..<offset + 12).withUnsafeBytes { $0.load(as: UInt16.self) }.littleEndian
                    guard numChannels == 1 else {
                        print("Unsupported number of channels: \(numChannels)")
                        return nil
                    }
                    
                    sampleRate = data.subdata(in: offset + 12..<offset + 16).withUnsafeBytes { $0.load(as: UInt32.self) }.littleEndian
                } else if subchunkID == "data" {
                    let numSamples = Int(subchunkSize) / MemoryLayout<Float>.size
                    samples.reserveCapacity(numSamples)
                    
                    for i in stride(from: offset + 8, to: offset + 8 + Int(subchunkSize), by: MemoryLayout<Float>.size) {
                        let sample = data.subdata(in: i..<i + MemoryLayout<Float>.size).withUnsafeBytes { $0.load(as: Float.self) }
                        samples.append(sample)
                    }
                    
                    break
                }
                
                offset += 8 + Int(subchunkSize)
            }
        } catch {
            print("Error reading WAV file: \(error)")
            return nil
        }
    }
}
