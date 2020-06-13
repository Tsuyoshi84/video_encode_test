import UIKit
import DSWaveformImage

class ViewController: UIViewController {
    @IBOutlet weak var topWaveformView: UIImageView!
    @IBOutlet weak var bottomWaveformView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let waveformImageDrawer = WaveformImageDrawer()
        let originalAudioURL = Bundle.main.url(forResource: "original", withExtension: "mp4")!
        let encodedAudioURL = Bundle.main.url(forResource: "encoded", withExtension: "mp4")!

        // always uses background thread rendering
        waveformImageDrawer.waveformImage(fromAudioAt: originalAudioURL,
                                          size: topWaveformView.bounds.size,
                                          style: .filled,
                                          position: .bottom) { image in
            // need to jump back to main queue
            DispatchQueue.main.async {
                self.topWaveformView.image = image
            }
        }

        let configuration = WaveformConfiguration(size: bottomWaveformView.bounds.size,
                                                  color: UIColor.blue,
                                                  style: .filled,
                                                  position: .top)

        waveformImageDrawer.waveformImage(fromAudioAt: encodedAudioURL, with: configuration) { image in
            DispatchQueue.main.async {
                self.bottomWaveformView.image = image
            }
        }

        // get access to the raw, normalized amplitude samples
        let waveformAnalyzer = WaveformAnalyzer(audioAssetURL: originalAudioURL)
        waveformAnalyzer?.samples(count: 10) { samples in
            print("sampled down to 10, results are \(samples ?? [])")
        }
    }

}

