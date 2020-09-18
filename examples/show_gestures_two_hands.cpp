// This example will show a hand in a default pose
// and then bend one joint and show the hand again
//
// This is a line-by-line code example

#include <iostream>
#include <string>

#include <boost/filesystem.hpp>
#include <boost/range/iterator_range.hpp>


// We will use OpenCV, so include the standard OpenCV header
#include "opencv2/opencv.hpp"

// This is our little library for showing file dialogs
#include "file_dialog.h"

// We need the HandPose data structure
#include "hand_pose.h"

// ..the HandRenderer class which is used to render a hand
#include "hand_renderer.h"

// ..and SceneSpec which tells us where the hand 3D scene data
// is located on disk, and how the hand 3D object relates to our
// model of joints.
#include "scene_spec.h"


std::vector<std::string> list_files_in_dir(const std::string & path)
{
    boost::filesystem::path initial_path(path);

    std::vector<std::string> retval;

    if (boost::filesystem::is_directory(initial_path))
    {
        std::cout << initial_path << " is a directory containing:" << std::endl;

        auto file_range = boost::make_iterator_range(boost::filesystem::directory_iterator(initial_path), {});
        for (auto & entry : file_range)
        {
            //std::cout << entry << std::endl;
            retval.push_back(entry.path().string());
        }
    }

    return retval;
}

// Don't forget to mention the libhand namespace
using namespace libhand;


enum joint_names
{
    pinky_base      = 0,
    pinky_middle    = 1,
    pinky_adv       = 2,
    ring_base       = 3,
    ring_middle     = 4,
    ring_adv        = 5,
    middle_base     = 6,
    middle_middle   = 7,
    middle_adv      = 8,
    index_base      = 9,
    index_middle    = 10,
    index_adv       = 11,
    thumb_base      = 12,
    thumb_middle    = 13,
    thumb_adv       = 14,
    wrist           = 15,
    arm             = 17
};


struct InputData
{
    HandRenderer    hand_renderer;
    SceneSpec       scene_spec;
    FullHandPose    hand_pose;
    cv::Mat         pic;
    const string    win_name = "Hand Pic";

    InputData(SceneSpec & scene, FullHandPose & pose)
        : scene_spec(scene)
        , hand_pose(pose)
    {

    }
};

void show_pose(const std::string & pose_name, InputData & input_data)
{
    try
    {
        input_data.hand_pose.Load(pose_name, input_data.scene_spec);
        //hand_pose.bend (arm) += 3.14159 * 2 / 2;

        input_data.hand_renderer.SetHandPose (input_data.hand_pose);

        // Then we will render the hand again and show it to the user.
        input_data.hand_renderer.RenderHand();

        int     font        = cv::FONT_HERSHEY_SIMPLEX;
        double  scale       = 0.5;
        int     thickness   = 2;

        const cv::Scalar magenta(255,   0,      255);

        cv::putText(input_data.pic, pose_name, cv::Point(10, 50), font, scale, magenta, thickness, 8);

        cv::imshow (input_data.win_name, input_data.pic);
        cv::waitKey();
    }
    catch (const std::exception &e)
    {
        cerr << "Unable to load pose: " << pose_name << " - exception: " << e.what() << endl;
    }
}


int main (int argc, char **argv)
{
    // Make sure to always catch exceptions around the LibHand code.
	// LibHand uses a "RAII" pattern to provide for a clean shutdown in
	// case of any errors.
	try
	{
        auto pose_list =  list_files_in_dir("../../poses/");

        std::sort(pose_list.begin(), pose_list.end());

#if 0
		// Ask the user to show the location of the scene spec file
		FileDialog dialog;
		dialog.SetTitle ("Please select a scene spec file");
		string file_name = dialog.Open();
#endif

        const std::string file_name = "../../hand_model/scene_spec.yml";

		// Process the scene spec file
        SceneSpec scene_spec (file_name);

        // Now we're going to change the hand pose and render again
        // The hand pose depends on the number of bones, which is specified
        // by the scene spec file.
        FullHandPose hand_pose (scene_spec.num_bones());


        /// Remember that input_data must have the same scope as scene_spec and hand_pose
        InputData input_data(scene_spec, hand_pose);


        std::cout << "Loaded hand with " << input_data.scene_spec.num_bones() << " bones." << std::endl;


        // Setup the hand renderer
        input_data.hand_renderer.Setup(1024, 768);




        // Tell the renderer to load the scene
        input_data.hand_renderer.LoadScene(input_data.scene_spec);

		// Now we render a hand using a default pose
        input_data.hand_renderer.RenderHand();

		// Open a window through OpenCV
        cv::namedWindow(input_data.win_name);
        //cv::setWindowProperty(input_data.win_name, )
        //cv::resizeWindow(input_data.win_name, 1024, 768);

		// We can get an OpenCV matrix from the rendered hand image
        input_data.pic = input_data.hand_renderer.pixel_buffer_cv();

		// And tell OpenCV to show the rendered hand
        cv::imshow (input_data.win_name, input_data.pic);
		cv::waitKey();


        for (auto & pose : pose_list)
        {
            show_pose(pose, input_data);
        }


		// We will bend the first joint, joint 0, by PI/2 radians (90 degrees)
		// hand_pose.bend (0) += 3.14159 / 2;

#if 0
        hand_pose.bend (arm) += 3.14159;
        hand_pose.bend (pinky_base) += 3.14159 / 4;




        hand_pose.Load("../../poses/a_ok.yml", scene_spec);
        hand_pose.bend (arm) += 3.14159 * 2 / 2;

        hand_renderer.SetHandPose (hand_pose);

        // Then we will render the hand again and show it to the user.
        hand_renderer.RenderHand();
        cv::imshow (win_name, pic);
        cv::waitKey();





        hand_pose.Load("../../poses/pointing_finger.yml", scene_spec);
        //hand_pose.bend (wrist) += 3.14159 * 2 / 2;
        hand_pose.bend (arm) += 3.14159 * 2 / 2;

        hand_renderer.SetHandPose (hand_pose);

        // Then we will render the hand again and show it to the user.
        hand_renderer.RenderHand();
        cv::imshow (win_name, pic);
        cv::waitKey();






        hand_pose.Load("../../poses/stop_it.yml", scene_spec);
        //hand_pose.bend (wrist) += 3.14159 * 1 / 4;
        hand_pose.bend (wrist) = 0;
        hand_pose.bend (arm) += 3.14159 * 2 / 2;

        hand_renderer.SetHandPose (hand_pose);

        // Then we will render the hand again and show it to the user.
        hand_renderer.RenderHand();
        cv::imshow (win_name, pic);
        cv::waitKey();


        hand_pose.Load("../../poses/thumb_up.yml", scene_spec);
        //hand_pose.bend (wrist) += 3.14159 * 1 / 4;
        hand_pose.bend (wrist) = 0;
        hand_pose.bend (arm) += 3.14159 * 2 / 2;

        hand_renderer.SetHandPose (hand_pose);

        // Then we will render the hand again and show it to the user.
        hand_renderer.RenderHand();
        cv::imshow (win_name, pic);
        cv::waitKey();
#endif

#if 0
        uint32_t joint_counter = 0;
        while (true)
        {
            hand_pose.bend (joint_counter++) += 3.14159 / 2;
            hand_renderer.SetHandPose (hand_pose);

            // Then we will render the hand again and show it to the user.
            hand_renderer.RenderHand();
            cv::imshow (win_name, pic);
            cv::waitKey();
        }
#endif
	}
	catch (const std::exception &e)
	{
		cerr << "Exception: " << e.what() << endl;
	}

	return 0;
}
